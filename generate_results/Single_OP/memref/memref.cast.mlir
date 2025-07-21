module {
  func.func @main(%arg0: memref<?x?xf32>, %arg1: memref<4xf32>, %arg2: memref<12x4xf32, strided<[4, 1], offset: 5>>) -> () {
    // Assert that the input dynamic shape matches the destination static shape.
    %cast1 = memref.cast %arg0 : memref<?x?xf32> to memref<4x4xf32>

    // Erase static shape information, replacing it with dynamic information.
    %cast2 = memref.cast %arg1 : memref<4xf32> to memref<?xf32>

    // Assert that the input dynamic shape matches the destination static stride.
    %cast3 = memref.cast %arg2 : memref<12x4xf32, strided<[4, 1], offset: 5>> to 
                                memref<12x4xf32, strided<[?, ?], offset: ?>>
    return
  }
}