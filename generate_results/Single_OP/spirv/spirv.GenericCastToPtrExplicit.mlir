module {
  func.func @main(%ptr: !spirv.ptr<f32, Generic>) -> !spirv.ptr<f32, Workgroup> {
    %result = spirv.GenericCastToPtrExplicit %ptr : !spirv.ptr<f32, Generic> to !spirv.ptr<f32, Workgroup>
    return %result : !spirv.ptr<f32, Workgroup>
  }

  func.func @example_function(%ptr: !spirv.ptr<f32, Generic>) -> !spirv.ptr<f32, Function> {
    %result_func = spirv.GenericCastToPtrExplicit %ptr : !spirv.ptr<f32, Generic> to !spirv.ptr<f32, Function>
    return %result_func : !spirv.ptr<f32, Function>
  }
}