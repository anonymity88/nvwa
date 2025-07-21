module {
  func.func @main(%ptr: !spirv.ptr<f32, Function>, %value: f32) {
    spirv.Store "Function" %ptr, %value : f32
    return
  }

  func.func @vector_example(%ptr: !spirv.ptr<vector<4xf32>, Function>, %value_vec: vector<4xf32>) {
    spirv.Store "Function" %ptr, %value_vec : vector<4xf32>
    return
  }

  func.func @aligned_example(%ptr: !spirv.ptr<i32, Function>, %value: i32) {
    spirv.Store "Function" %ptr, %value ["Aligned", 4] : i32
    return
  }
}