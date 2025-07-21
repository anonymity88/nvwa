module {
  func.func @main() {
    %memref = memref.alloc() : memref<8x64xf32, 1>  // Allocate memory on GPU
    %dep = "gpu.wait"() { async = true } : () -> !gpu.async.token  // Assume a previous async dependency

    %token = gpu.dealloc async [%dep] %memref : memref<8x64xf32, 1>  // Deallocate the GPU memory

    return
  }
}