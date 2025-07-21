module {
  func.func @main(%x: ui32, %min: ui32, %max: ui32) -> ui32 {
    %result = spirv.GL.UClamp %x, %min, %max : ui32
    return %result : ui32
  }

  func.func @vector_example(%v: vector<4xi32>, %min: vector<4xi32>, %max: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.GL.UClamp %v, %min, %max : vector<4xi32>
    return %result_vec : vector<4xi32>
  }
}