import os
import json

if __name__ == '__main__':

    target_path = r"/conf/Ops_LoweringPass.json"

    with open(target_path, 'r') as f:
        jsonData = json.load(f)


    dialectSet = {'affine', 'async',
                  'bufferization',
                  'gpu', 'linalg',
                  'memref',
                  'scf','tensor', 'vector', 'spriv',
                  'tosa'}

