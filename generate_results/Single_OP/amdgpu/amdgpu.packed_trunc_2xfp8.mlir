module {
  func.func @main(%arg0: f32, %arg1: f32, %arg2: vector<4xf8E4M3FNUZ>) -> vector<4xf8E4M3FNUZ> {
    // Correct the instantiation format of the operation using the `word` keyword correctly
    %result = amdgpu.packed_trunc_2xfp8 %arg0, %arg1 into %arg2 [word 0] : f32 to vector<4xf8E4M3FNUZ> into vector<4xf8E4M3FNUZ>
    return %result : vector<4xf8E4M3FNUZ>
  }
}