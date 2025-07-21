module {
  func.func @main(%sampled_image: !spirv.sampled_image<!spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>) -> !spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown> {
    %result = spirv.Image %sampled_image : !spirv.sampled_image<!spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>
    return %result : !spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>
  }

  func.func @vector_example(%sampled_image_vector: !spirv.sampled_image<!spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>) -> !spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown> {
    %result_vec = spirv.Image %sampled_image_vector : !spirv.sampled_image<!spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>
    return %result_vec : !spirv.image<f32, Cube, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>
  }
}