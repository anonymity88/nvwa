module {
  func.func @smull_func(%arg0: vector<4xi16>, %arg1: vector<4xi16>) -> vector<4xi32> {
    %result = arm_neon.intr.smull %arg0, %arg1 : vector<4xi16> to vector<4xi32>
    return %result : vector<4xi32>
  }

  func.func @sdot_func(%arg0: vector<2xi32>, %arg1: vector<2x4xi8>, %arg2: vector<2x4xi8>) -> vector<2xi32> {
    %result = arm_neon.2d.sdot %arg0, %arg1, %arg2 : vector<2x4xi8>, vector<2x4xi8> to vector<2xi32>
    return %result : vector<2xi32>
  }

  func.func @usmmla_func(%arg0: vector<4xi32>, %arg1: vector<16xi8>, %arg2: vector<16xi8>) -> vector<4xi32> {
    %result = arm_neon.intr.usmmla %arg0, %arg1, %arg2 : vector<16xi8> to vector<4xi32>
    return %result : vector<4xi32>
  }

  func.func @vector_arm_neon_mixed_types(%lhs: vector<2x8xi8>, %rhs: vector<2x8xi4>, %acc : vector<2x2xi32>) -> vector<2x2xi32> {
    %lhs_extsi = arith.extsi %lhs : vector<2x8xi8> to vector<2x8xi32>
    %rhs_extsi = arith.extsi %rhs : vector<2x8xi4> to vector<2x8xi32>
    %res = vector.contract {indexing_maps = [affine_map<(d0, d1, d2) -> (d0, d2)>, affine_map<(d0, d1, d2) -> (d1, d2)>, affine_map<(d0, d1, d2) -> (d0, d1)>], iterator_types = ["parallel", "parallel", "reduction"], kind = #vector.kind<add>} %lhs_extsi, %rhs_extsi, %acc : vector<2x8xi32>, vector<2x8xi32> into vector<2x2xi32>
    return %res : vector<2x2xi32>
  }

  func.func @main(
    %arg0: vector<4xi16>, %arg1: vector<4xi16>,
    %arg2: vector<2xi32>, %arg3: vector<2x4xi8>, %arg4: vector<2x4xi8>,
    %arg5: vector<4xi32>, %arg6: vector<16xi8>, %arg7: vector<16xi8>,
    %arg8: vector<2x8xi8>, %arg9: vector<2x8xi4>, %arg10: vector<2x2xi32>
  ) -> (vector<4xi32>, vector<2xi32>, vector<4xi32>, vector<2x2xi32>) {
    %smull_result = call @smull_func(%arg0, %arg1) : (vector<4xi16>, vector<4xi16>) -> vector<4xi32>
    
    %sdot_result = call @sdot_func(%arg2, %arg3, %arg4) : (vector<2xi32>, vector<2x4xi8>, vector<2x4xi8>) -> vector<2xi32>
    
    %usmmla_result = call @usmmla_func(%smull_result, %arg6, %arg7) : (vector<4xi32>, vector<16xi8>, vector<16xi8>) -> vector<4xi32>
    
    %vector_result = call @vector_arm_neon_mixed_types(%arg8, %arg9, %arg10) : (vector<2x8xi8>, vector<2x8xi4>, vector<2x2xi32>) -> vector<2x2xi32>
    
    return %smull_result, %sdot_result, %usmmla_result, %vector_result : vector<4xi32>, vector<2xi32>, vector<4xi32>, vector<2x2xi32>
  }
}