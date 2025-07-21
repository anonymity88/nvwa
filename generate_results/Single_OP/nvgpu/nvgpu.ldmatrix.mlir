module {
  func.func @main() -> vector<4x2xf16> {
    // Allocate memory with explicit dimensions (assuming some size e.g., 8 for illustration)
    %srcMemref = memref.alloc() : memref<8x8xf16, 3>
    %c0 = arith.constant 0 : index
    // Load matrix fragment from memory to registers
    %result = nvgpu.ldmatrix %srcMemref[%c0, %c0] {numTiles = 4 : i32, transpose = false} :
      memref<8x8xf16, 3> -> vector<4x2xf16>

    return %result : vector<4x2xf16>
  }
}