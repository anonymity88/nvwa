module {
  func.func @main(%arg: memref<400x400xi32>, %i: index, %j: index) -> () {
    // Prefetch data from the given memref location
    memref.prefetch %arg[%i, %j], read, locality<3>, data : memref<400x400xi32>
    
    return
  }
}