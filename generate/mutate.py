import os
from datetime import datetime
import generate_utils
import json
import IR_analysis


class MLIRMutator:
    def __init__(self, dialect="linalg", totaltimes=10, IRscount=1, max_retries=10, date = "test"):
        self.date = date
        self.dialect = dialect
        self.totaltimes = totaltimes
        self.IRscount = IRscount
        self.max_retries = max_retries
        self.target = f"official_IRs/Dialect/{self.dialect}"
        self.results_dir = f'generate_results/mutate_IRs/{self.dialect}'
        if not os.path.exists(self.results_dir):
            os.makedirs(self.results_dir)
        
        self.fuzz_crash_dir = f"fuzz_results/{self.date}/crash"
        if not os.path.exists(self.fuzz_crash_dir):
            os.makedirs(self.fuzz_crash_dir)

    def setDialect(self, new_dialect):
        self.dialect = new_dialect
        self.target = f"official_IRs/Dialect/{self.dialect}"
        self.results_dir = f'generate_results/mutate_IRs/{self.dialect}'
        if not os.path.exists(self.results_dir):
            os.makedirs(self.results_dir)
        print(f"Dialect set to: {self.dialect}")
    
    def set_results_dir(self, new__dir):
        if new__dir:
            self.results_dir = new__dir
            if not os.path.exists(self.results_dir):
                os.makedirs(self.results_dir)
        else:
            self.results_dir = f'generate_results/mutate_IRs/{self.dialect}'
            if not os.path.exists(self.results_dir):
                os.makedirs(self.results_dir)


    def analyseDialect(self, input_string):
        json_result = IR_analysis.IRAnalysis(input_string)
         # 解析JSON结果
        parsed_json = json.loads(json_result)

        # 如果解析后的字典为空，跳过处理
        if not parsed_json:
            return ""

        # 统计哪个方言的列表最长，选择那个方言
        max_dialect = max(parsed_json, key=lambda k: len(parsed_json[k]))
        return max_dialect
    

    def mutate(self, origin_mlir, dialect, model="gpt-4o", temperature=0.4):
        retries = 0
        self.setDialect(dialect)
        if not os.path.isdir(self.target):
            return "", retries
        file_names, file_names_str, prompt1, prompt2, combined_content = generate_utils.fill_text_with_files(
            self.target, self.dialect, self.IRscount, "mutate", origin_mlir
        )

        content = '\n'.join(f"// {line}" for line in combined_content.splitlines())

        messages = [{"role": "system", "content": prompt1}]

        with open('prompt/prompt_mutate_verify1.txt', 'r') as file:
            prompt6 = file.read()
        prompt6 = prompt6.replace("$$", file_names_str)
        # print(prompt6)

        with open('prompt/prompt_mutate_verify2.txt', 'r') as file:
            prompt7 = file.read()
        prompt7 = prompt7.replace("$$", file_names_str)
        # print(prompt7)

        while retries < self.max_retries:
            if retries >= 2:
                model = "gpt-4o-mini"
            try:
                gpt_response = generate_utils.get_gpt_response(messages, model, temperature)
            except Exception as e:
                print(f"Error in GPT request: {e}")
                break

            # print(gpt_response)

            mlir_ir = generate_utils.extract_mlir_ir(gpt_response)

            if mlir_ir:
                # mlir_ir = mlir_ir.replace(" func ", "func.func ")
                # mlir_ir = mlir_ir.replace("func.func.func", "func.func ")
                # mlir_ir = mlir_ir.replace("func.func func", "func.func ")

                with open('generate/tests.mlir', 'w') as file:
                    file.write(mlir_ir + "\n\n\n" + content)

                return_code, message = generate_utils.run_mlir_opt('generate/tests.mlir')

                if return_code == 0:
                    if generate_utils.has_single_module(mlir_ir) and generate_utils.contains_required_op(mlir_ir):
                        # print(message)
                        print(f"MLIR IR muteta successfully for OP: {file_names}.")
                        os.makedirs(self.results_dir, exist_ok=True)
                        file_path = generate_utils.get_next_file_path(self.results_dir, '.mlir')
                        with open(file_path, 'w') as file:
                            file.write(mlir_ir + "\n\n\n" + content)

                        # 分析生成IR的复杂度
                        IR_analysis.compute_complexity(file_path)
                        return mlir_ir, retries + 1
                    
                    elif not generate_utils.contains_required_op(mlir_ir):
                        print(f"The required OP ({file_names}) are not all in the generated MLIR IR.Attempting {retries + 1}/{self.max_retries} try")
                        messages.append({"role": "system", "content": f"{prompt6}"})
                    elif not generate_utils.has_single_module(mlir_ir):
                        messages.append({"role": "system", "content": f"{prompt7}"})

                elif return_code == 1:
                    print(f"Error in MLIR IR, Attempting {retries + 1}/{self.max_retries} try: \n{message}")
                    messages.append({"role": "system", "content": f"{prompt2}{message}"})

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
                return origin_mlir, retries + 1

            retries += 1

        if retries >= self.max_retries:
            print("Reached maximum number of retries without success.")
            return origin_mlir, retries + 1
        
        return origin_mlir, retries + 1


if __name__ == "__main__":
    mutator = MLIRMutator(IRscount=2)
    count = 1
    while count < mutator.totaltimes:
        dialect = mutator.analyseDialect("")
        mutator.set_results_dir("")
        dialect = "tosa"
        mutator.mutate("",dialect)

        count += 1

