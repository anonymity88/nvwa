import os
import argparse
from datetime import datetime
import generate_utils
import IR_analysis
import ast

class Generator:
    def __init__(self, dialect="affine", totaltimes=10, max_retries = 4, gentype = "single", date = "1008", OPscount = 5, requiredOPscount = 3):
        self.date = date
  
        self.dialect = dialect
        self.gentype = gentype
        self.fail_OPs = f"generate_results/fail_OPs/{self.dialect}_fail_OPs.txt"
        self.directory = f"OPs/{self.dialect}"
        self.results_dir = f"generate_results/Single_OP/{self.dialect}"
        if not os.path.exists(self.results_dir):
            os.makedirs(self.results_dir)
        
        self.fuzz_crash_dir = f"fuzz_results/{self.date}/crash"
        if not os.path.exists(self.fuzz_crash_dir):
            os.makedirs(self.fuzz_crash_dir)
        
        self.prompt1_path = f"prompt/prompt_{gentype}.txt"
        self.prompt_result_path = f"prompt/prompt_{gentype}1.txt"
        self.prompt2_path = f"prompt/prompt_{gentype}_modify.txt"
        self.prompt3_path = f"prompt/prompt_{gentype}_verify.txt"
        
        #multi生成时总生成次数
        self.totaltimes = totaltimes

        #单次生成迭代总数
        self.max_retries = max_retries
        self.failed_files = []

        #IR长度
        self.OPscount = OPscount 
        #IR至少需要含有的OP数量
        self.requiredOPscount = requiredOPscount
        

        self.target = f"generate_results/Single_OP/{dialect}"
        self.multi_results_dir = f'generate_results/multi_IRs/{dialect}'
        if not os.path.exists(self.multi_results_dir):
            os.makedirs(self.multi_results_dir)

    def set_results_dir(self, new__dir):
        self.multi_results_dir = new__dir

    def setDialect(self, new_dialect):
        self.dialect = new_dialect
        self.fail_OPs = f"generate_results/fail_OPs/{self.dialect}_fail_OPs.txt"
        self.directory = f"OP_web/{self.dialect}"
        self.results_dir = f"generate_results/Single_OP/{self.dialect}"

        if not os.path.exists(self.results_dir):
            os.makedirs(self.results_dir)
        
        self.target = f"generate_results/Single_OP/{self.dialect}"
        self.multi_results_dir = f'generate_results/multi_IRs/{self.dialect}'
        if not os.path.exists(self.multi_results_dir):
            os.makedirs(self.multi_results_dir)

    def set_gentype(self, new_gentype):
        self.gentype = new_gentype
        
        # 更新与 gentype 相关的路径
        self.prompt1_path = f"prompt/prompt_{new_gentype}.txt"
        self.prompt_result_path = f"prompt/prompt_{new_gentype}1.txt"
        self.prompt2_path = f"prompt/prompt_{new_gentype}_modify.txt"
        self.prompt3_path = f"prompt/prompt_{new_gentype}_verify.txt"


    def ISrequired_op(self, mlir_ir, required_op):
        return required_op in mlir_ir


    #依次生成一整个方言中所有的OP
    def generate_single_dialect(self, model="gpt-4o-mini"):
        self.set_gentype("single")
        txt_files = [f for f in os.listdir(self.directory) if f.endswith('.txt')]

        for txt_file in txt_files:
            file_name = os.path.splitext(txt_file)[0]

            with open(os.path.join(self.directory, txt_file), 'r') as f:
                file_content = f.read()
            self.generate_single_OP(file_name, file_content, model)

            if self.failed_files:
                with open(self.fail_OPs, 'w') as file:
                    file.write(str(self.failed_files))
                    print(str(self.failed_files))


    #用于重点再次生成之前生成失败的单OP
    #从fail_OPs文件中读取之前生成失败的OP列表，依次生成，可以考虑使用更精准的模型   
    def generate_single_renew(self, model="gpt-4o"):
        self.set_gentype("single")

        with open(self.fail_OPs, 'r') as file:
            ops_list = eval(file.read())  # 将文件内容转换为列表
        
        for op in ops_list:
            file_name = op
            file_path = os.path.join(self.directory, f"{file_name}.txt")
            
            if not os.path.exists(file_path):
                print(f"File {file_path} does not exist.")
                self.failed_files.append(file_name)
                continue

            with open(file_path, 'r') as f:
                file_content = f.read()

            self.generate_single_OP(file_name, file_content, model)
                # 输出所有生成失败的文件名到文件中
            print(str(self.failed_files))

        with open(self.fail_OPs, 'w') as file:
            file.write(str(self.failed_files))  # 将列表格式化为字符串写入文件
            print(str(self.failed_files))



    #一次生成单个OP
    def generate_single_OP(self, file_name, file_content, model="gpt-4o-mini", temperature=0.4):
        with open(self.prompt1_path, 'r') as template_file:
            template_text = template_file.read()
        
        with open(self.prompt2_path, 'r') as file:
            prompt2 = file.read()

        with open(self.prompt3_path, 'r') as file:
            prompt3 = file.read()

        retries = 0


        prompt1 = template_text.replace("AAA", file_name).replace("@@@@", file_content)
        prompt1 = generate_utils.fill_Examples_generate(prompt1, self.dialect)

        with open(self.prompt_result_path, 'w') as output_file:
            output_file.write(prompt1)

        prompt2 = prompt2.replace("AAA", file_name)
        prompt3 = prompt3.replace("AAA", file_name)

        messages = [{"role": "system", "content": prompt1}]


        while retries < self.max_retries:
            try:
                gpt_response = generate_utils.get_gpt_response(messages, model, temperature)
            except Exception as e:
                print(f"Error in GPT request: {e}")
                self.failed_files.append(file_name)
                break

            mlir_ir = generate_utils.extract_mlir_ir(gpt_response)
            if mlir_ir:
                # mlir_ir = mlir_ir.replace(" func ","func.func ")
                # mlir_ir = mlir_ir.replace("func.func.func","func.func ")
                # mlir_ir = mlir_ir.replace("func.func func","func.func ")

                with open('generate/tests.mlir', 'w') as file:
                    file.write(mlir_ir)
                
                return_code, message = generate_utils.run_mlir_opt('generate/tests.mlir')
                
                if return_code == 0:
                    if self.ISrequired_op(mlir_ir, file_name):
                        print(f"MLIR IR processed successfully for OP: {file_name}.")
                        os.makedirs(self.results_dir, exist_ok=True)
                        file_path = f"{self.results_dir}/{file_name}.mlir"
                        with open(file_path, 'w') as file:
                            file.write(mlir_ir)
                        # 分析生成IR的复杂度
                        IR_analysis.compute_complexity(file_path)
                        break
                    else:
                        print(f"The required OP ({file_name}) was not found in the generated MLIR IR.")
                        messages.append({"role": "system", "content": f"{prompt3}"})

                elif return_code == 1:
                    print(f"Error in MLIR IR: \n{message}")
                    messages.append({"role": "system", "content": f"{prompt2}{mlir_ir}\n\nHere is the content of the Error message:\n{message}"})
                else:
                    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                    print(f"Crash in MLIR IR: \n{message}")
                    message = current_time + "\n" + message + "\n\nreturncode\n" + str(return_code) + "\nmlir\n" + mlir_ir
                    crash_path = generate_utils.get_next_file_path(self.fuzz_crash_dir, '.log')
                    with open(crash_path, 'w') as file:
                        file.write(message)
                    messages.append({"role": "system", "content": f"{prompt2}{message}"})

            else:
                print("Failed to extract MLIR IR from GPT response.")
                break

            retries += 1

        if retries >= self.max_retries:
            print(f"Reached maximum number of retries for file: {file_name}")
            self.failed_files.append(file_name)

    
    def contains_required_op(self, mlir_ir, required_ops):

        # 统计 mlir_ir 中包含的 required_ops 数量
        match_count = sum(1 for op in required_ops if op in mlir_ir)
        
        print(f"{match_count} required OPs in generated IRs")

        # 判断是否匹配预订数量的OP
        return match_count >= self.requiredOPscount 


    #循环从某种方言的种子池中
    def generate_multi(self, model="gpt-4o-mini", temperature=0.4):
        self.set_gentype("multi")
        
        # self.target = f"OPs/{self.dialect}"
        
        retries = 0
        if not os.path.isdir(self.target):
            print("The dialect does not initialize a single OP IR pool")
            return "", retries
        # 首先随机挑选要生成的OPs
        file_names, file_names_str, prompt1, prompt2, combined_content = generate_utils.fill_text_with_files(self.target, self.dialect, self.OPscount, self.gentype, "")#最后的空函数表示源mlir，仅变异时使用

        content = '\n'.join(f"// {line}" for line in combined_content.splitlines())

        messages = [{"role": "system", "content": prompt1}]

        with open(f'prompt/prompt_{self.gentype}_verify1.txt', 'r') as file:
            prompt3 = file.read()
        prompt3 = prompt3.replace("$$", file_names_str)
        # print(prompt3)

        with open(f'prompt/prompt_{self.gentype}_verify2.txt', 'r') as file:
            prompt4 = file.read()
        prompt4 = prompt4.replace("$$", file_names_str)
        # print(prompt4)

        while retries < self.max_retries:
            try:
                gpt_response = generate_utils.get_gpt_response(messages, model, temperature)
            except Exception as e:
                print(f"Error in GPT request: {e}")
                break

            # print(gpt_response)
            
            mlir_ir = generate_utils.extract_mlir_ir(gpt_response)

            if mlir_ir:
                
                # mlir_ir = mlir_ir.replace(" func ","func.func ")  # 确保替换仅在需要时进行
                # mlir_ir = mlir_ir.replace("func.func.func","func.func ")  # 确保替换仅在需要时进行
                # mlir_ir = mlir_ir.replace("func.func func","func.func ")  # 确保替换仅在需要时进行

                with open('generate/tests.mlir', 'w') as file:
                    file.write(mlir_ir + "\n\n\n" + content)
                
                return_code, message = generate_utils.run_mlir_opt('generate/tests.mlir')
                
                if return_code == 0:            
                    if generate_utils.Iscombined(mlir_ir) and self.contains_required_op(mlir_ir, file_names) == True:
                        # print(message)
                        print(f"MLIR IR processed successfully for OP: {file_names}.")
                        # 写出到results目录
                        os.makedirs(self.multi_results_dir, exist_ok=True)
                        file_path = generate_utils.get_next_file_path(self.multi_results_dir, '.mlir')
                        with open(file_path, 'w') as file:
                            file.write(mlir_ir + "\n\n\n" + content)
                        # 分析生成IR的复杂度
                        IR_analysis.compute_complexity(file_path)
                        return mlir_ir, retries + 1
                    
                    elif self.contains_required_op(mlir_ir, file_names) == False:
                        print(f"The required OP ({file_names}) are not all in the generated MLIR IR.Attempting {retries + 1}/{self.max_retries} try")
                        messages.append({"role": "system", "content": f"{prompt3}"})
                    elif generate_utils.Iscombined(mlir_ir) == False:
                        messages.append({"role": "system", "content": f"{prompt4}"})

                elif return_code == 1:
                    print(f"Error in MLIR IR: \n{message}.Attempting {retries + 1}/{self.max_retries} try")
                    messages.append({"role": "system", "content": f"{prompt2}{message}"})
                
                #生成过程中出现crash
                else:
                    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                    print(f"Crash in MLIR IR: \n{message}.Attempting {retries + 1}/{self.max_retries} try")
                    message = current_time + "\n" + message + "\n\nreturncode\n" + str(return_code) + "\nmlir\n" + mlir_ir
                    crash_path = generate_utils.get_next_file_path(self.fuzz_crash_dir, '.log')
                    with open(crash_path, 'w') as file:
                        file.write(message)
                    messages.append({"role": "system", "content": f"{prompt2}{message}"})

            else:
                print("Failed to extract MLIR IR from GPT response.")
                return "", retries + 1
            
            retries += 1

        if retries >= self.max_retries:
            print("Reached maximum number of retries without success.")
            return "", retries + 1
        
        return "", retries + 1
    
    
    #循环从某种方言的种子池中
    def generate_multi_temperature(self, model="gpt-4o-mini", temperature=0.4):
        self.set_gentype("multi")
        retries = 0
        
        with open(f"prompt/prompt_{self.gentype}_file_names.txt", 'r') as file:
            file_names = file.read()
            file_names = ast.literal_eval(file_names)  # 转换为列表
        with open(f"prompt/prompt_{self.gentype}_combined_content.txt", 'r') as file:
            combined_content = file.read()
        content = '\n'.join(f"// {line}" for line in combined_content.splitlines())

        with open(f'prompt/prompt_{self.gentype}1.txt', 'r') as file:
            prompt1 = file.read()
        
        with open(f"prompt/prompt_{self.gentype}_modify1.txt", 'r') as file:
            prompt2 = file.read()
        
        messages = [{"role": "system", "content": prompt1}]

        file_names_str = ", ".join(file_names)
        
        with open(f'prompt/prompt_{self.gentype}_verify1.txt', 'r') as file:
            prompt3 = file.read()
        prompt3 = prompt3.replace("$$", file_names_str)
        with open(f'prompt/prompt_{self.gentype}_verify2.txt', 'r') as file:
            prompt4 = file.read()
        prompt4 = prompt4.replace("$$", file_names_str)

        while retries < self.max_retries:
            try:
                gpt_response = generate_utils.get_gpt_response(messages, model, temperature)
            except Exception as e:
                print(f"Error in GPT request: {e}")
                break

            # print(gpt_response)
            
            mlir_ir = generate_utils.extract_mlir_ir(gpt_response)

            if mlir_ir:
                
                with open('generate/tests.mlir', 'w') as file:
                    file.write(mlir_ir + "\n\n\n" + content)
                
                return_code, message = generate_utils.run_mlir_opt('generate/tests.mlir')
                
                if return_code == 0:            
                    if generate_utils.Iscombined(mlir_ir) and self.contains_required_op(mlir_ir, file_names) == True:

                        print(f"MLIR IR processed successfully for OP: {file_names}.")
                        # 写出到results目录
                        os.makedirs(self.multi_results_dir, exist_ok=True)
                        file_path = generate_utils.get_next_file_path(self.multi_results_dir, '.mlir')
                        with open(file_path, 'w') as file:
                            file.write(mlir_ir + "\n\n\n" + content)
                        # 分析生成IR的复杂度
                        IR_analysis.compute_complexity(file_path)
                        return mlir_ir, retries + 1
                    
                    elif self.contains_required_op(mlir_ir, file_names) == False:
                        print(f"The required OP ({file_names}) are not all in the generated MLIR IR.Attempting {retries + 1}/{self.max_retries} try")
                        messages.append({"role": "system", "content": f"{prompt3}"})
                    elif generate_utils.Iscombined(mlir_ir) == False:
                        messages.append({"role": "system", "content": f"{prompt4}"})

                elif return_code == 1:
                    print(f"Error in MLIR IR: \n{message}.Attempting {retries + 1}/{self.max_retries} try")
                    messages.append({"role": "system", "content": f"{prompt2}{message}"})
                
                #生成过程中出现crash
                else:
                    current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                    print(f"Crash in MLIR IR: \n{message}.Attempting {retries + 1}/{self.max_retries} try")
                    message = current_time + "\n" + message + "\n\nreturncode\n" + str(return_code) + "\nmlir\n" + mlir_ir
                    crash_path = generate_utils.get_next_file_path(self.fuzz_crash_dir, '.log')
                    with open(crash_path, 'w') as file:
                        file.write(message)
                    messages.append({"role": "system", "content": f"{prompt2}{message}"})

            else:
                print("Failed to extract MLIR IR from GPT response.")
                return "", retries + 1
            
            retries += 1

        if retries >= self.max_retries:
            print("Reached maximum number of retries without success.")
            return "", retries + 1
        
        return "", retries + 1


if __name__ == "__main__":
    # 设置参数解析器
    parser = argparse.ArgumentParser(description="Run the generator with specified dialect and mode.")
    parser.add_argument("--dialect", default="tosa", help="The dialect to use (e.g., affine, arith).")
    parser.add_argument("--opt", required=True, choices=["single", "renew", "multi"], 
                        help="The mode of operation: 'single', 'renew', or 'multi'.")
    parser.add_argument("--model",
                        help="Select the model you want to interact with.")

    # 解析参数
    args = parser.parse_args()
    dialect = args.dialect
    opt = args.opt

    if args.model:
        model = args.model
    else:
        model = "gpt-4o-mini"  


    # 创建 Generator 实例
    generator = Generator(dialect=dialect)

    # 根据模式执行相应逻辑
    if opt == "single":
        generator.generate_single_dialect(model)
    elif opt == "renew":
        generator.generate_single_renew(model)
    elif opt == "multi":
        count = 1
        while count < generator.totaltimes:
            generator.generate_multi(model)
            count += 1
            