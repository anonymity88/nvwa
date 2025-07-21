module {
  func.func @main(%arg0: memref<?xf32, 5>, %arg1: memref<5x4xi32, 3>) -> () {
    // Cast a generic pointer to workgroup-local memory
    %cast1 = memref.memory_space_cast %arg0 : memref<?xf32, 5> to memref<?xf32>
    
    // Cast a workgroup-local memory back into a generic pointer
    %cast2 = memref.memory_space_cast %arg1 : memref<5x4xi32, 3> to memref<5x4xi32>
    
    return
  }
}