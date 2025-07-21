module {
  func.func @main(%x: f32) -> i32 {
    %result = spirv.Bitcast %x : f32 to i32
    return %result : i32
  }

  func.func @vector_example(%v: vector<4xf32>) -> vector<2xi64> {
    %result_vec = spirv.Bitcast %v : vector<4xf32> to vector<2xi64>
    return %result_vec : vector<2xi64>
  }

  func.func @pointer_example(%ptr: !spirv.ptr<f32, Function>) -> !spirv.ptr<i32, Function> {
    %result_ptr = spirv.Bitcast %ptr : !spirv.ptr<f32, Function> to !spirv.ptr<i32, Function>
    return %result_ptr : !spirv.ptr<i32, Function>
  }
}