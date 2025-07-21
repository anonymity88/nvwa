func.func @apply_scale_test_vector(%arg0 : vector<4xi32>, %arg1 : vector<4xi32>, %arg2 : vector<4xi8>) -> (vector<4xi32>) {
  %res = tosa.apply_scale %arg0, %arg1, %arg2 {double_round = true} : (vector<4xi32>, vector<4xi32>, vector<4xi8>) -> vector<4xi32>
  return %res : vector<4xi32>
}