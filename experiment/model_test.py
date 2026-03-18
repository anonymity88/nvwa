# experiment/parameter_sensitivity_test.py

import os
import csv
from generate import mlir_gen

# ---------- 实验配置 ----------
DIALECTS = ["tosa", "affine", "linalg", "spirv"]  # 四种方言
TOP_P_VALUES = [round(i*0.1,1) for i in range(0,11)]  # 0,0.1,...,1
TEMPERATURE_VALUES = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5] 
REPEAT_TIMES = 50
MODEL = "gpt-4o-mini"

os.makedirs("experiment", exist_ok=True)
TOPP_CSV = os.path.join("experiment", "top_p_sensitivity.csv")
TEMP_CSV = os.path.join("experiment", "temperature_sensitivity.csv")

# ---------- Top-p 实验 ----------
with open(TOPP_CSV, 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(["dialect", "top_p", "success_count", "success_rate", "avg_retry"])

for dialect in DIALECTS:
    print(f"\n=== Top-p Sensitivity for {dialect} ===")
    generator = mlir_gen.Generator(dialect=dialect)
    fixed_temp = 0.4  # Top-p 实验固定 temperature
    
    for top_p in TOP_P_VALUES:
        success_count = 0
        total_retries = 0
        
        for trial in range(REPEAT_TIMES):
            mlir_ir, retries = generator.generate_multi(model=MODEL, temperature=fixed_temp, top_p=top_p)
            if mlir_ir:
                success_count += 1
            total_retries += retries

        success_rate = success_count / REPEAT_TIMES
        avg_retry = total_retries / REPEAT_TIMES

        print(f"{dialect} | top_p={top_p} -> success {success_count}/{REPEAT_TIMES}, avg_retry={avg_retry:.2f}")

        with open(TOPP_CSV, 'a', newline='') as f:
            writer = csv.writer(f)
            writer.writerow([dialect, top_p, success_count, f"{success_rate:.2f}", f"{avg_retry:.2f}"])

# ---------- Temperature 实验 ----------
with open(TEMP_CSV, 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(["dialect", "temperature", "success_count", "success_rate", "avg_retry"])

for dialect in DIALECTS:
    print(f"\n=== Temperature Sensitivity for {dialect} ===")
    generator = mlir_gen.Generator(dialect=dialect)
    fixed_top_p = 0.9  # Temperature 实验固定 top-p

    for temp in TEMPERATURE_VALUES:
        success_count = 0
        total_retries = 0

        for trial in range(REPEAT_TIMES):
            mlir_ir, retries = generator.generate_multi(model=MODEL, temperature=temp, top_p=fixed_top_p)
            if mlir_ir:
                success_count += 1
            total_retries += retries

        success_rate = success_count / REPEAT_TIMES
        avg_retry = total_retries / REPEAT_TIMES

        print(f"{dialect} | temp={temp} -> success {success_count}/{REPEAT_TIMES}, avg_retry={avg_retry:.2f}")

        with open(TEMP_CSV, 'a', newline='') as f:
            writer = csv.writer(f)
            writer.writerow([dialect, temp, success_count, f"{success_rate:.2f}", f"{avg_retry:.2f}"])
            