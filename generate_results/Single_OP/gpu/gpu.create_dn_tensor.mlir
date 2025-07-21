module {
  func.func @main() {
    // Define the dimensions of the tensor to be created
    %dim1 = arith.constant 5 : index
    %dim2 = arith.constant 5 : index

    // Allocate a memref that will hold values for a 5 x 5 dense tensor
    %mem = memref.alloc() : memref<5x5xf64> // A 5 x 5 dense tensor

    // Assuming a previous async dependency operation for demonstration
    %dep = "gpu.wait"() { async = true } : () -> !gpu.async.token

    // Create the dense tensor with the provided memref and dimensions
    %tensor, %token = gpu.create_dn_tensor async [%dep] %mem, %dim1, %dim2 : 
      index, index into memref<5x5xf64>

    return
  }
}