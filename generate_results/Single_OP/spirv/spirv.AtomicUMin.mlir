module {
  func.func @main(%pointer: !spirv.ptr<i32, StorageBuffer>, %value: i32) -> i32 {
    %result = spirv.AtomicUMin <Device> <None> %pointer, %value : !spirv.ptr<i32, StorageBuffer>
    return %result : i32
  }
}