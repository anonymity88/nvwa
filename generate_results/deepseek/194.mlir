module {
  func.func @combined(
    %sampled_image: !spirv.sampled_image<!spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>,
    %sampled_image_vector: !spirv.sampled_image<!spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>,
    %x: f32,
    %v: vector<4xf32>,
    %v_h16: vector<3xf16>,
    %x_int: i32,
    %y_int: i32,
    %v1: vector<4xi32>,
    %v2: vector<4xi32>
  ) -> (
    !spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>,
    !spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>,
    f32,
    vector<4xf32>,
    vector<3xf16>,
    i32,
    vector<4xi32>
  ) {
    // Image operations
    %image_result = spirv.Image %sampled_image : !spirv.sampled_image<!spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>
    %image_vector_result = spirv.Image %sampled_image_vector : !spirv.sampled_image<!spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>

    // Logarithm operations
    %log_result = spirv.CL.log %x : f32
    %log_vector_result = spirv.CL.log %v : vector<4xf32>
    %log_vector_h16_result = spirv.CL.log %v_h16 : vector<3xf16>

    // Division operations
    %sdiv_result = spirv.SDiv %x_int, %y_int : i32
    %sdiv_vector_result = spirv.SDiv %v1, %v2 : vector<4xi32>

    // Return all results
    return %image_result, %image_vector_result, %log_result, %log_vector_result, %log_vector_h16_result, %sdiv_result, %sdiv_vector_result : 
           !spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>,
           !spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>,
           f32,
           vector<4xf32>,
           vector<3xf16>,
           i32,
           vector<4xi32>
  }
}