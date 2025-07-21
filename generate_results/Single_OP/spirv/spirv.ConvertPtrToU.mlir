module {
  func.func @main(%ptr: !spirv.ptr<i32, Generic>) -> i32 {
    %result = spirv.ConvertPtrToU %ptr : !spirv.ptr<i32, Generic> to i32
    return %result : i32
  }
}