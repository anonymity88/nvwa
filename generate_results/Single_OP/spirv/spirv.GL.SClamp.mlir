module {
  func.func @main(%x: i32, %min: i32, %max: i32) -> i32 {
    %result = spirv.GL.SClamp %x, %min, %max : i32
    return %result : i32
  }

  func.func @vector_example(%v: vector<4xi32>, %min_vec: vector<4xi32>, %max_vec: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.GL.SClamp %v, %min_vec, %max_vec : vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}