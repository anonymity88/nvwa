module {
  func.func @main(
    %ptr: !spirv.ptr<f32, Generic>,
    %base: vector<3xi32>, %offset: i8, %count: i8,
    %base_vec: vector<4xi32>, %offset_vec: i8, %count_vec: i8,
    %x: f32, %y: f32, %a: f32,
    %x_vec: vector<4xf32>, %y_vec: vector<4xf32>, %a_vec: vector<4xf32>,
    %x_short: vector<3xf16>, %y_short: vector<3xf16>, %a_short: vector<3xf16>,
    %arg0: i32, %arg1: vector<3xi32>,
    %bitwise_arg0: i32, %bitwise_arg1: vector<3xi32>
  ) -> (
    !spirv.ptr<f32, CrossWorkgroup>,
    vector<3xi32>, vector<4xi32>,
    f32, vector<4xf32>, vector<3xf16>,
    i32, vector<3xi32>,
    i32, vector<3xi32>
  ) {
    // Call combined function
    %cast_result, %bitfield_result, %bitfield_vec_result, 
    %mix_result, %mix_vec_result, %mix_short_result = 
      call @combined(
        %ptr, %base, %offset, %count, %base_vec, %offset_vec, %count_vec,
        %x, %y, %a, %x_vec, %y_vec, %a_vec, %x_short, %y_short, %a_short
      ) : (
        !spirv.ptr<f32, Generic>,
        vector<3xi32>, i8, i8,
        vector<4xi32>, i8, i8,
        f32, f32, f32,
        vector<4xf32>, vector<4xf32>, vector<4xf32>,
        vector<3xf16>, vector<3xf16>, vector<3xf16>
      ) -> (
        !spirv.ptr<f32, CrossWorkgroup>,
        vector<3xi32>, vector<4xi32>,
        f32, vector<4xf32>, vector<3xf16>
      )

    // Call lsr_shift_overflow function
    %shift_result0, %shift_result1 = call @lsr_shift_overflow(%arg0, %arg1) : (i32, vector<3xi32>) -> (i32, vector<3xi32>)

    // Call bitwise_and_x_0 function
    %bitwise_result0, %bitwise_result1 = call @bitwise_and_x_0(%bitwise_arg0, %bitwise_arg1) : (i32, vector<3xi32>) -> (i32, vector<3xi32>)

    return %cast_result, %bitfield_result, %bitfield_vec_result, 
           %mix_result, %mix_vec_result, %mix_short_result,
           %shift_result0, %shift_result1,
           %bitwise_result0, %bitwise_result1 : 
           !spirv.ptr<f32, CrossWorkgroup>,
           vector<3xi32>, vector<4xi32>,
           f32, vector<4xf32>, vector<3xf16>,
           i32, vector<3xi32>,
           i32, vector<3xi32>
  }

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
    %cast_result = spirv.GenericCastToPtr %ptr : !spirv.ptr<f32, Generic> to !spirv.ptr<f32, CrossWorkgroup>

    %bitfield_result = spirv.BitFieldUExtract %base, %offset, %count : vector<3xi32>, i8, i8
    %bitfield_vec_result = spirv.BitFieldUExtract %base_vec, %offset_vec, %count_vec : vector<4xi32>, i8, i8

    %mix_result = spirv.CL.mix %x, %y, %a : f32
    %mix_vec_result = spirv.CL.mix %x_vec, %y_vec, %a_vec : vector<4xf32>
    %mix_short_result = spirv.CL.mix %x_short, %y_short, %a_short : vector<3xf16>

    return %cast_result, %bitfield_result, %bitfield_vec_result, 
           %mix_result, %mix_vec_result, %mix_short_result : 
           !spirv.ptr<f32, CrossWorkgroup>,
           vector<3xi32>, vector<4xi32>,
           f32, vector<4xf32>, vector<3xf16>
  }

  func.func @lsr_shift_overflow(%arg0: i32, %arg1: vector<3xi32>) -> (i32, vector<3xi32>) {
    %c32 = spirv.Constant 32 : i32
    %cv = spirv.Constant dense<[6, 18, 128]> : vector<3xi32>
    %0 = spirv.ShiftRightLogical %arg0, %c32 : i32, i32
    %1 = spirv.ShiftRightLogical %arg1, %cv : vector<3xi32>, vector<3xi32>
    return %0, %1 : i32, vector<3xi32>
  }

  func.func @bitwise_and_x_0(%arg0 : i32, %arg1 : vector<3xi32>) -> (i32, vector<3xi32>) {
    %c0 = spirv.Constant 0 : i32
    %cv0 = spirv.Constant dense<0> : vector<3xi32>
    %0 = spirv.BitwiseAnd %arg0, %c0 : i32
    %1 = spirv.BitwiseAnd %arg1, %cv0 : vector<3xi32>
    return %0, %1 : i32, vector<3xi32>
  }
}