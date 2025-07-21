module {
  func.func @main(%ptr: !spirv.ptr<f32, Generic>) -> !spirv.ptr<f32, CrossWorkgroup> {
    %result = spirv.GenericCastToPtr %ptr : !spirv.ptr<f32, Generic> to !spirv.ptr<f32, CrossWorkgroup>
    return %result : !spirv.ptr<f32, CrossWorkgroup>
  }
}