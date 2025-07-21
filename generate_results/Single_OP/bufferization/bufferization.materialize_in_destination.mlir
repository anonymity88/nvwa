module {
  func.func @main(%source: tensor<4x4xf32>, %dest: tensor<4x4xf32>) -> tensor<4x4xf32> {
    // Use bufferization.materialize_in_destination to materialize data from source in dest
    %result = bufferization.materialize_in_destination %source in %dest
                : (tensor<4x4xf32>, tensor<4x4xf32>) -> tensor<4x4xf32>

    return %result : tensor<4x4xf32>
  }

  func.func @main_memref(%source: tensor<4x4xf32>, %dest: memref<4x4xf32>) {
    // Use bufferization.materialize_in_destination to materialize data from source in dest buffer with writable and restrict
    bufferization.materialize_in_destination %source in restrict writable %dest
                : (tensor<4x4xf32>, memref<4x4xf32>) -> ()

    return
  }
}