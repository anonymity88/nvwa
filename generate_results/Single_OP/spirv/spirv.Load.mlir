module {
  func.func @main(%ptr: !spirv.ptr<f32, Function>) -> f32 {
    %result = spirv.Load "Function" %ptr : f32
    return %result : f32
  }

  func.func @load_with_memory_access(%ptr: !spirv.ptr<i32, Function>) -> i32 {
    %result_volatile = spirv.Load "Function" %ptr ["Volatile"] : i32
    return %result_volatile : i32
  }

  func.func @load_with_aligned_access(%ptr: !spirv.ptr<f64, Function>) -> f64 {
    %result_aligned = spirv.Load "Function" %ptr ["Aligned", 8] : f64
    return %result_aligned : f64
  }
}