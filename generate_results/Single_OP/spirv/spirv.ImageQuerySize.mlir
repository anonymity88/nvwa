module {
  func.func @main(%image: !spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown>) -> vector<2xi32> {
    %result = spirv.ImageQuerySize %image : !spirv.image<i32, Dim2D, NoDepth, NonArrayed, SingleSampled, NoSampler, Unknown> -> vector<2xi32>
    return %result : vector<2xi32>
  }
}