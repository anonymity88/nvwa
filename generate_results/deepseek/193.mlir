module {
  func.func @combined(
    %ptr: !spirv.ptr<f32, Generic>,
    %base: vector<3xi32>, %offset: i8, %count: i8,
    %base_vec: vector<4xi32>, %offset_vec: i8, %count_vec: i8,
    %x: f32, %y: f32, %a: f32,
    %x_vec: vector<4xf32>, %y_vec: vector<4xf32>, %a_vec: vector<4xf32>,
    %x_short: vector<3xf16>, %y_short: vector<3xf16>, %a_short: vector<3xf16>
  ) -> (
    !spirv.ptr<f32, CrossWorkgroup>,
    vector<3xi32>, vector<4xi32>,
    f32, vector<4xf32>, vector<3xf16>
  ) {
    // Generic pointer cast
    %cast_result = spirv.GenericCastToPtr %ptr : !spirv.ptr<f32, Generic> to !spirv.ptr<f32, CrossWorkgroup>

    // Bit field unsigned extraction operations
    %bitfield_result = spirv.BitFieldUExtract %base, %offset, %count : vector<3xi32>, i8, i8
    %bitfield_vec_result = spirv.BitFieldUExtract %base_vec, %offset_vec, %count_vec : vector<4xi32>, i8, i8

    // Mix operations (linear interpolation)
    %mix_result = spirv.CL.mix %x, %y, %a : f32
    %mix_vec_result = spirv.CL.mix %x_vec, %y_vec, %a_vec : vector<4xf32>
    %mix_short_result = spirv.CL.mix %x_short, %y_short, %a_short : vector<3xf16>

    // Return all results
    return %cast_result, %bitfield_result, %bitfield_vec_result, 
           %mix_result, %mix_vec_result, %mix_short_result : 
           !spirv.ptr<f32, CrossWorkgroup>,
           vector<3xi32>, vector<4xi32>,
           f32, vector<4xf32>, vector<3xf16>
  }
}