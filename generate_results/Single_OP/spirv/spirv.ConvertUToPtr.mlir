module {
  func.func @main(%value: i32) -> !spirv.ptr<i32, Generic> {
    %result = spirv.ConvertUToPtr %value : i32 to !spirv.ptr<i32, Generic>
    return %result : !spirv.ptr<i32, Generic>
  }
}