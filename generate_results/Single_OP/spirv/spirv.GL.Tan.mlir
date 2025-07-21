module {
  func.func @main(%value: vector<4xf32>) -> vector<4xf32> {
    %result = spirv.GL.Tan %value : vector<4xf32>
    return %result : vector<4xf32>
  }
}