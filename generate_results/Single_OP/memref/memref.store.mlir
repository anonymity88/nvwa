module {
  func.func @main(%value: f32, %memref: memref<4x4xf32>, %i: index, %j: index) -> () {
    // Store the value into the memref location specified by indices
    memref.store %value, %memref[%i, %j] : memref<4x4xf32>
    
    return
  }
}