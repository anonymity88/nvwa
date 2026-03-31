import json
import os
import re
from collections import Counter

CONFIG_PATH = "generate/config.json"

# ========================================
# 原始方言列表
# ========================================
DIALECTS = ['affine', 'amdgpu', 'amx', 'arith', 'arm_neon', 'arm_sve',
            'async', 'bufferization', 'cf', 'complex', 'emitc', 
            'func', 'gpu', 'index', 'irdl', 'linalg', 'math', 
            'memref', 'mesh', 'ml_program', 'mpi', 'nvgpu', 'pdl', 
            'pdl_interp', 'quant', 'scf', 'shape', 'spirv', 
            'tensor', 'tosa', 'vector', 'x86vector']

# ========================================
# 1. 覆盖度统计功能：读取文件夹并统计算子频次
# ========================================
def count_dialects_in_corpus(corpus_dir):
    """
    读取指定文件夹下所有 .mlir 文件，统计各个方言算子的出现总次数
    """
    dialect_counts = Counter({d: 0 for d in DIALECTS})
    
    if not os.path.exists(corpus_dir):
        print(f"[ERROR] 语料库目录 {corpus_dir} 不存在")
        return dialect_counts

    # 匹配 MLIR 算子的正则，例如 %0 = arith.constant ... 或 affine.for ...
    # 模式为：方言名.算子名
    pattern = re.compile(r'([a-z0-9_]+)\.[a-z0-9_]+')

    for filename in os.listdir(corpus_dir):
        if filename.endswith(".mlir"):
            file_path = os.path.join(corpus_dir, filename)
            try:
                with open(file_path, "r", encoding="utf-8") as f:
                    content = f.read()
                    matches = pattern.findall(content)
                    for d_name in matches:
                        if d_name in dialect_counts:
                            dialect_counts[d_name] += 1
            except Exception as e:
                print(f"[WARN] 读取文件 {filename} 失败: {e}")
                
    return dialect_counts

# ========================================
# 2. 初始化配置函数
# ========================================
def init_config():
    """
    如果配置文件不存在，则创建并初始化
    """
    if os.path.exists(CONFIG_PATH):
        print(f"[INFO] 配置文件 {CONFIG_PATH} 已存在，跳过初始化。")
        return

    num_dialects = len(DIALECTS)
    avg_weight = round(1.0 / num_dialects, 4) if num_dialects > 0 else 0

    dialect_info = {}
    for name in DIALECTS:
        dialect_info[name] = {
            "OPscount": 3,
            "requiredOPscount": 2,
            "model": "gpt-4o-mini",
            "max_retries": 4,      # 按要求改为 4
            "mut_attempts": 2,
            "W_current": avg_weight,      # 初始赋 0
            "W_0": avg_weight,     # 赋平均值
            "W_min": 0.0,
            "W_max": 1.0
        }

    config = {
        "dialect_info": dialect_info,
        "model_info": {
            "model_name": "gpt-4o-mini",
            "model_type": "online"
        },
        "model_params": {
            "temperature": 0.4,
            "top_p": 0.9,
            "top_k": 50,
            "max_tokens": 4096
        },
        "interaction_params": {
            "N_shot": 3,
            "N_ci": 4,
            "N_A": 500,
            "time_limit": 120
        },
        "feedback_params": {
            "theta": 0.1,      # 学习率/更新系数
            "epsilon": 1e-6,
            "lambda_V": 0.5,    # 覆盖度权重 (论文公式 4-3 中的系数)
            "lambda_S": 0.5     # BUG 权重
        }
    }

    os.makedirs(os.path.dirname(CONFIG_PATH), exist_ok=True)
    with open(CONFIG_PATH, "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2, ensure_ascii=False)
    print(f"[INFO] 配置已初始化并保存到 {CONFIG_PATH} (W_0 均值为 {avg_weight})")

# ========================================
# 3. 核心功能：结合循环反馈更新配置
# ========================================
def update_config_with_feedback(manual_bugs, corpus_dir):
    """
    结合 BUG 数量和覆盖度信息更新 W_current
    manual_bugs: dict {方言名: BUG数}
    corpus_dir: 上一轮用例存放文件夹
    """
    if not os.path.exists(CONFIG_PATH):
        init_config()

    with open(CONFIG_PATH, "r", encoding="utf-8") as f:
        config = json.load(f)

    # 1. 获取当前覆盖度统计
    op_counts = count_dialects_in_corpus(corpus_dir)
    
    # 2. 计算反馈分值 (归一化)
    total_ops = sum(op_counts.values()) + 1e-9
    total_bugs = sum(manual_bugs.values()) + 1e-9
    
    f_params = config["feedback_params"]
    theta = f_params["theta"]
    lambda_V = f_params["lambda_V"]
    lambda_S = f_params["lambda_S"]

    dialect_info = config["dialect_info"]
    
    print(f"[UPDATE] 开始基于论文第四章公式更新权重...")
    
    for name in DIALECTS:
        if name not in dialect_info:
            continue
            
        # 覆盖度评分 F_cov: 该方言算子占比
        f_cov = op_counts[name] / total_ops
        
        # 缺陷评分 F_bug: 该方言 BUG 占比
        f_bug = manual_bugs.get(name, 0) / total_bugs
        
        # 综合反馈得分 Score
        score = lambda_V * f_cov + lambda_S * f_bug
        
        # 论文公式：W_next = (1 - theta) * W_old + theta * Score
        # 如果是第一轮更新且 W_current 为 0，则 W_old 取 W_0
        w_old = dialect_info[name]["W_current"]
        if w_old == 0:
            w_old = dialect_info[name]["W_0"]
            
        w_next = (1 - theta) * w_old + theta * score
        
        # 更新并保留 6 位小数
        dialect_info[name]["W_current"] = round(w_next, 6)

    config["dialect_info"] = dialect_info

    with open(CONFIG_PATH, "w", encoding="utf-8") as f:
        json.dump(config, f, indent=2, ensure_ascii=False)
    print(f"[INFO] 权重动态反馈更新完成。")


# ========================================
if __name__ == "__main__":
    # 步骤 1: 初始化
    init_config()

    # 步骤 2: 手动输入 BUG 数量 (模拟功能 1)
    # 提示：实际使用时可以通过 input() 获取，这里给出示例格式
    current_round_bugs = {
        "affine": 10,
        "linalg": 5,
        "tosa": 15
    }

    # 步骤 3: 指定上一轮生成的 MLIR 文件目录 (模拟功能 2)
    last_round_corpus = "generate_results/deepseek" 
    # 请确保该目录下有 .mlir 文件，否则覆盖度项将为 0
    
    if not os.path.exists(last_round_corpus):
        os.makedirs(last_round_corpus, exist_ok=True)
        print(f"[WARN] 文件夹 {last_round_corpus} 为空，覆盖度统计将为0。")

    # 步骤 4: 执行公式计算并更新 JSON (模拟功能 3)
    update_config_with_feedback(current_round_bugs, last_round_corpus)
    
    