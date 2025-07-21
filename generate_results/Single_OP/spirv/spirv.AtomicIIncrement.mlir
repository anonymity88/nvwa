module {
  func.func @main(%pointer: !spirv.ptr<i32, StorageBuffer>) -> i32 {
    %result = spirv.AtomicIIncrement <Device> <None> %pointer : !spirv.ptr<i32, StorageBuffer>
    return %result : i32
  }
}