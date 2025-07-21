module {
  func.func @main(%source: tensor<4x4xf32>, %dest: tensor<4x4xf32>) -> tensor<4x4xf32> {
    // Use bufferization.materializeindestination to materialize data from source to dest
    %result = bufferization.materialize_in_destination %source in %dest
                : (tensor<4x4xf32>, tensor<4x4xf32>) -> tensor<4x4xf32>

    return %result : tensor<4x4xf32>
  }

  func.func @main_memref(%source: tensor<4x4xf32>, %dest: memref<4x4xf32>) {
    // Use bufferization.materializeindestination to materialize data from source in dest buffer with writable
    bufferization.materialize_in_destination %source in writable %dest
                : (tensor<4x4xf32>, memref<4x4xf32>) -> ()

    return
  }
}