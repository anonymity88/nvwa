module {
  func.func @main(%ptr: !spirv.ptr<f32, CrossWorkgroup>) -> !spirv.ptr<f32, Generic> {
    %result = spirv.PtrCastToGeneric %ptr : !spirv.ptr<f32, CrossWorkgroup> to !spirv.ptr<f32, Generic>
    return %result : !spirv.ptr<f32, Generic>
  }

  func.func @another_example(%ptr2: !spirv.ptr<i32, Workgroup>) -> !spirv.ptr<i32, Generic> {
    %result_vec = spirv.PtrCastToGeneric %ptr2 : !spirv.ptr<i32, Workgroup> to !spirv.ptr<i32, Generic>
    return %result_vec : !spirv.ptr<i32, Generic>
  }
}