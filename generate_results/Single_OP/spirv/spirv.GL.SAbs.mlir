module {
  func.func @main(%x: i32) -> i32 {
    %result = spirv.GL.SAbs %x : i32
    return %result : i32
  }

  func.func @vector_example(%v: vector<3xi16>) -> vector<3xi16> {
    %result_vec = spirv.GL.SAbs %v : vector<3xi16>
    return %result_vec : vector<3xi16>
  }
}