module {
  func.func @main(%sampled_image: !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %coordinate: vector<4xf32>, %dref: f32) -> vector<4xi32> {
    %result = spirv.ImageDrefGather %sampled_image : !spirv.sampled_image<!spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>>, %coordinate : vector<4xf32>, %dref : f32 -> vector<4xi32>
    return %result : vector<4xi32>
  }
}