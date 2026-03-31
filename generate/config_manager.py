import json
import os

class NuwaConfig:
    def __init__(self, config_path="config.json"):
        """初始化配置字典，加载论文第四章所述的所有关键参数"""
        if not os.path.exists(config_path):
            raise FileNotFoundError(f"未找到配置文件: {config_path}")
            
        with open(config_path, 'r', encoding='utf-8') as f:
            self._config = json.load(f)
            
        # 类别分组参数
        self.dialect_info = self._config.get("dialect_info", {})
        self.model_info = self._config.get("model_info", {})
        self.model_params = self._config.get("model_params", {})
        self.interaction = self._config.get("interaction_params", {})
        self.feedback = self._config.get("feedback_params", {})

    def update_dialect_weight(self, dialect, new_weight):
        """基于执行反馈动态更新方言的生成优化权重 W(di)"""
        if dialect in self.dialect_info:
            w_min = self.dialect_info[dialect]["W_min"]
            w_max = self.dialect_info[dialect]["W_max"]
            # 限制新权重的范围，确保在 [W_min, W_max] 之间
            clamped_weight = max(w_min, min(new_weight, w_max))
            self.dialect_info[dialect]["W_current"] = clamped_weight

    def save_config(self, save_path="config.json"):
        """将反馈更新后的配置字典持久化"""
        with open(save_path, 'w', encoding='utf-8') as f:
            json.dump(self._config, f, indent=4, ensure_ascii=False)
            
            