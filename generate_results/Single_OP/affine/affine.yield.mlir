module {
  func.func @main() -> () {
    // Define an affine for loop
    affine.for %i = 0 to 10 {
      // Allocate a memref buffer
      %buffer = memref.alloca() : memref<10xi32>
      
      // Create a constant value to store in the buffer
      %value = arith.constant 42 : i32
      
      // Store the value in the buffer at index %i
      affine.store %value, %buffer[%i] : memref<10xi32>
      
      // Yield operation inside the loop; no specific type needed for %i, as it is of type index
      affine.yield
    }

    return
  }
}