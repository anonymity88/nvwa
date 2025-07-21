module {
  func.func @sdot_2d(%arg0: vector<2xi32>, %arg1: vector<2x4xi8>, %arg2: vector<2x4xi8>) -> vector<2xi32> {
    %result = arm_neon.2d.sdot %arg0, %arg1, %arg2 : vector<2x4xi8>, vector<2x4xi8> to vector<2xi32>
    return %result : vector<2xi32>
  }

  func.func @sdot_intr(%arg0: vector<4xi32>, %arg1: vector<16xi8>, %arg2: vector<16xi8>) -> vector<4xi32> {
    %result = arm_neon.intr.sdot %arg0, %arg1, %arg2 : vector<16xi8>, vector<16xi8> to vector<4xi32>
    return %result : vector<4xi32>
  }

  func.func @usmmla(%arg0: vector<4xi32>, %arg1: vector<16xi8>, %arg2: vector<16xi8>) -> vector<4xi32> {
    %result = arm_neon.intr.usmmla %arg0, %arg1, %arg2 : vector<16xi8> to vector<4xi32>
    return %result : vector<4xi32>
  }

  func.func @main(%arg0: vector<2xi32>, %arg1: vector<2x4xi8>, %arg2: vector<2x4xi8>, 
                 %arg3: vector<4xi32>, %arg4: vector<16xi8>, %arg5: vector<16xi8>) -> (vector<2xi32>, vector<4xi32>, vector<4xi32>) {
    // First compute 2D SDOT
    %sdot_2d_result = call @sdot_2d(%arg0, %arg1, %arg2) : (vector<2xi32>, vector<2x4xi8>, vector<2x4xi8>) -> vector<2xi32>
    
    // Then compute SDOT intrinsic (using same inputs as USMMLA for demonstration)
    %sdot_intr_result = call @sdot_intr(%arg3, %arg4, %arg5) : (vector<4xi32>, vector<16xi8>, vector<16xi8>) -> vector<4xi32>
    
    // Finally compute USMMLA (using same inputs as SDOT intrinsic)
    %usmmla_result = call @usmmla(%arg3, %arg4, %arg5) : (vector<4xi32>, vector<16xi8>, vector<16xi8>) -> vector<4xi32>
    
    return %sdot_2d_result, %sdot_intr_result, %usmmla_result : vector<2xi32>, vector<4xi32>, vector<4xi32>
  }
}