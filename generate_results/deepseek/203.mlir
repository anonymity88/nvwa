module {
  func.func @reshape_tensor(%src: tensor<4x1xf32>, %shape: tensor<2xi32>) -> tensor<2x2xf32> {
    %dst = tensor.reshape %src(%shape) : (tensor<4x1xf32>, tensor<2xi32>) -> tensor<2x2xf32>
    return %dst : tensor<2x2xf32>
  }

  func.func @get_tensor_dims(%A: tensor<4x?xf32>) -> (index, index) {
    %c0 = arith.constant 0 : index
    %x = tensor.dim %A, %c0 : tensor<4x?xf32>
    
    %c1 = arith.constant 1 : index
    %y = tensor.dim %A, %c1 : tensor<4x?xf32>

    return %x, %y : index, index
  }

  func.func @scatter_tensor(%source: tensor<1x2xf32>, %dest: tensor<4x4x4xf32>, %indices: tensor<1x2x3xi32>) -> tensor<4x4x4xf32> {
    %out = tensor.scatter %source into %dest[%indices] scatter_dims([0, 1, 2]) unique : 
      (tensor<1x2xf32>, tensor<4x4x4xf32>, tensor<1x2x3xi32>) -> tensor<4x4x4xf32>
    return %out : tensor<4x4x4xf32>
  }

  func.func @main(%src: tensor<4x1xf32>, %shape: tensor<2xi32>, %A: tensor<4x?xf32>, %source: tensor<1x2xf32>, %dest: tensor<4x4x4xf32>, %indices: tensor<1x2x3xi32>) -> (tensor<2x2xf32>, index, index, tensor<4x4x4xf32>) {
    %reshaped = call @reshape_tensor(%src, %shape) : (tensor<4x1xf32>, tensor<2xi32>) -> tensor<2x2xf32>
    %dim0, %dim1 = call @get_tensor_dims(%A) : (tensor<4x?xf32>) -> (index, index)
    %scattered = call @scatter_tensor(%source, %dest, %indices) : (tensor<1x2xf32>, tensor<4x4x4xf32>, tensor<1x2x3xi32>) -> tensor<4x4x4xf32>
    return %reshaped, %dim0, %dim1, %scattered : tensor<2x2xf32>, index, index, tensor<4x4x4xf32>
  }
}