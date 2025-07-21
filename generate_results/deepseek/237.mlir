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

  func.func @vector_arm_neon_k_unroll(%lhs: vector<2x16xi8>, %rhs: vector<2x16xi4>, %acc : vector<2x2xi32>) -> vector<2x2xi32> {
    %lhs_extsi = arith.extsi %lhs : vector<2x16xi8> to vector<2x16xi32>
    %rhs_extsi = arith.extsi %rhs : vector<2x16xi4> to vector<2x16xi32>
    %res = vector.contract {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %lhs_extsi, %rhs_extsi, %acc : vector<2x16xi32>, vector<2x16xi32> into vector<2x2xi32>
    return %res : vector<2x2xi32>
  }

  func.func @main(%arg0: vector<2xi32>, %arg1: vector<2x4xi8>, %arg2: vector<2x4xi8>, 
                 %arg3: vector<4xi32>, %arg4: vector<16xi8>, %arg5: vector<16xi8>,
                 %arg6: vector<2x16xi8>, %arg7: vector<2x16xi4>, %arg8: vector<2x2xi32>) 
                 -> (vector<2xi32>, vector<4xi32>, vector<4xi32>, vector<2x2xi32>) {
    %sdot_2d_result = call @sdot_2d(%arg0, %arg1, %arg2) : (vector<2xi32>, vector<2x4xi8>, vector<2x4xi8>) -> vector<2xi32>
    
    %sdot_intr_result = call @sdot_intr(%arg3, %arg4, %arg5) : (vector<4xi32>, vector<16xi8>, vector<16xi8>) -> vector<4xi32>
    
    %usmmla_result = call @usmmla(%arg3, %arg4, %arg5) : (vector<4xi32>, vector<16xi8>, vector<16xi8>) -> vector<4xi32>
    
    %vector_result = call @vector_arm_neon_k_unroll(%arg6, %arg7, %arg8) : (vector<2x16xi8>, vector<2x16xi4>, vector<2x2xi32>) -> vector<2x2xi32>
    
    return %sdot_2d_result, %sdot_intr_result, %usmmla_result, %vector_result : vector<2xi32>, vector<4xi32>, vector<4xi32>, vector<2x2xi32>
  }
}