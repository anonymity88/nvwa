module {
  func.func @main(%pointer: !spirv.ptr<i32, StorageBuffer>, %value: i32) -> i32 {
    %original_value = spirv.AtomicIAdd <Device> <None> %pointer, %value : !spirv.ptr<i32, StorageBuffer>
    return %original_value : i32
  }

  func.func @vector_example(%pointer: !spirv.ptr<i32, StorageBuffer>, %value: i32) -> i32 {
    %original_value_vec = spirv.AtomicIAdd <Device> <None> %pointer, %value : !spirv.ptr<i32, StorageBuffer>
    return %original_value_vec : i32
  }
}