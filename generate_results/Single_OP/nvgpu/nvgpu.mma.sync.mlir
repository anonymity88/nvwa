module {
  func.func @main(%matrixA: vector<4x2xf16>, %matrixB: vector<2x2xf16>, %matrixC: vector<2x2xf32>) -> vector<2x2xf32> {
    // Warp-level MMA operation
    %res = nvgpu.mma.sync (%matrixA, %matrixB, %matrixC) {mmaShape = [16, 8, 16]} : 
      (vector<4x2xf16>, vector<2x2xf16>, vector<2x2xf32>) -> vector<2x2xf32>

    return %res : vector<2x2xf32>
  }
}