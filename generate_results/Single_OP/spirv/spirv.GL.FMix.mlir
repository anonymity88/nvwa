module {
  func.func @main(%x: vector<4xf32>, %y: vector<4xf32>, %a: vector<4xf32>) -> vector<4xf32> {
    %result = spirv.GL.FMix %x : vector<4xf32>, %y : vector<4xf32>, %a : vector<4xf32> -> vector<4xf32>
    return %result : vector<4xf32>
  }
}