module {
  func.func @main() {
    %memref = memref.alloc() : memref<10xi32>
    %unranked_memref = memref.cast %memref : memref<10xi32> to memref<*xi32>
    gpu.host_unregister %unranked_memref : memref<*xi32>
    return
  }
}