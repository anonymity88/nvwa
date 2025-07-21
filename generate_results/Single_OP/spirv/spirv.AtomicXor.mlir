module {
  func.func @main(%pointer: !spirv.ptr<i32, StorageBuffer>, %value: i32) -> i32 {
    %result = spirv.AtomicXor <Device> <None> %pointer, %value : !spirv.ptr<i32, StorageBuffer>
    return %result : i32
  }

  // Example for another valid use-case with 64-bit integer
  func.func @example_64bit(%pointer: !spirv.ptr<i64, StorageBuffer>, %value: i64) -> i64 {
    %result = spirv.AtomicXor <Device> <None> %pointer, %value : !spirv.ptr<i64, StorageBuffer>
    return %result : i64
  }
}