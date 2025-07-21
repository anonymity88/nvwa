module {
  func.func @main(%pointer: !spirv.ptr<f32, StorageBuffer>, %value: f32) -> f32 {
    %result = spirv.EXT.AtomicFAdd <Device> <None> %pointer, %value : !spirv.ptr<f32, StorageBuffer>
    return %result : f32
  }
}