module {
  func.func @main() -> () {
    // Allocate a memref of type memref<8x64xf32>
    %0 = memref.alloc() : memref<8x64xf32, affine_map<(d0, d1) -> (d0, d1)>>

    // Deallocate the memref
    memref.dealloc %0 : memref<8x64xf32, affine_map<(d0, d1) -> (d0, d1)>>

    return
  }
}