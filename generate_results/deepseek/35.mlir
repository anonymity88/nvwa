module {
  func.func @smull_func(%arg0: vector<4xi16>, %arg1: vector<4xi16>) -> vector<4xi32> {
    %result = arm_neon.intr.smull %arg0, %arg1 : vector<4xi16> to vector<4xi32>
    return %result : vector<4xi32>
  }

  func.func @usmmla_func(%arg0: vector<4xi32>, %arg1: vector<16xi8>, %arg2: vector<16xi8>) -> vector<4xi32> {
    %result = arm_neon.intr.usmmla %arg0, %arg1, %arg2 : vector<16xi8> to vector<4xi32>
    return %result : vector<4xi32>
  }

  func.func @smmla_func(%arg0: vector<4xi32>, %arg1: vector<16xi8>, %arg2: vector<16xi8>) -> vector<4xi32> {
    %result = arm_neon.intr.smmla %arg0, %arg1, %arg2 : vector<16xi8> to vector<4xi32>
    return %result : vector<4xi32>
  }

  func.func @main(%arg0: vector<4xi16>, %arg1: vector<4xi16>, 
                  %arg2: vector<4xi32>, %arg3: vector<16xi8>, %arg4: vector<16xi8>,
                  %arg5: vector<4xi32>, %arg6: vector<16xi8>, %arg7: vector<16xi8>) -> (vector<4xi32>, vector<4xi32>, vector<4xi32>) {
    // First compute smull result
    %smull_result = call @smull_func(%arg0, %arg1) : (vector<4xi16>, vector<4xi16>) -> vector<4xi32>
    
    // Then compute usmmla result using smull result as accumulator
    %usmmla_result = call @usmmla_func(%smull_result, %arg3, %arg4) : (vector<4xi32>, vector<16xi8>, vector<16xi8>) -> vector<4xi32>
    
    // Finally compute smmla result using usmmla result as accumulator
    %smmla_result = call @smmla_func(%usmmla_result, %arg6, %arg7) : (vector<4xi32>, vector<16xi8>, vector<16xi8>) -> vector<4xi32>
    
    return %smull_result, %usmmla_result, %smmla_result : vector<4xi32>, vector<4xi32>, vector<4xi32>
  }
}