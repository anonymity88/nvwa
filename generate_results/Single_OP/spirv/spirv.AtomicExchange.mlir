module {
  func.func @main(%pointer: !spirv.ptr<i32, Workgroup>, %value: i32) -> i32 {
    %original_value = spirv.AtomicExchange <Workgroup> <Acquire> %pointer, %value : !spirv.ptr<i32, Workgroup>
    return %original_value : i32
  }

  func.func @float_example(%pointer: !spirv.ptr<f32, Workgroup>, %value: f32) -> f32 {
    %original_value_float = spirv.AtomicExchange <Workgroup> <Acquire> %pointer, %value : !spirv.ptr<f32, Workgroup>
    return %original_value_float : f32
  }
}