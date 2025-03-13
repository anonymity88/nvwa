import os
import json

if __name__ == '__main__':

    target_path = r"/conf/Ops_LoweringPass.json"

    with open(target_path, 'r') as f:
        jsonData = json.load(f)


    allkeys = jsonData.keys()
    jsonfile = {}
    for key in allkeys:
        dia_dict = {}
        print(key)
        print(jsonData[key]["OPS"])
        new_ops = [item["OPS_NAME"] for item in jsonData[key]["OPS"]]
        dia_dict["OPS"] = new_ops
        dia_dict["PASS"] = jsonData[key]["PASS"]

        jsonfile[key] = dia_dict



    # target_path = r"/home/workdir/tracer/fuzz_tool/conf/Ops_LoweringPass1.json"
    # with open(target_path, 'w') as f:
    #     jsonData = json.dump(jsonfile,f,indent=4)

