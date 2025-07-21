module {
  func.func @main(%tensor: tensor<1024x1024xf64>) {
    // Deallocate the tensor's underlying storage format using bufferization.dealloc_tensor
    bufferization.dealloc_tensor %tensor : tensor<1024x1024xf64>

    return
  }
}