module {
  func.func @insert_slice_into_tensor(%source: tensor<4x?x4xf32>, %dest: tensor<8x16x4xf32>, %o0: index, %o1: index, %o2: index, %sz1: index, %st1: index) -> tensor<8x16x4xf32> {
    %result = tensor.insert_slice %source into %dest[%o0, %o1, %o2][4, %sz1, 4][1, %st1, 1] : tensor<4x?x4xf32> into tensor<8x16x4xf32>
    return %result : tensor<8x16x4xf32>
  }

  func.func @pad_tensor(%arg0: tensor<10xi32>) -> tensor<18xi32> {
    %c0_i32 = arith.constant 0 : i32
    %padded = tensor.pad %arg0 low[3] high[5] {
      ^bb0(%arg1: index):
        tensor.yield %c0_i32 : i32
    } : tensor<10xi32> to tensor<18xi32>
    return %padded : tensor<18xi32>
  }

  func.func @reshape_tensor(%src: tensor<4x1xf32>, %shape: tensor<2xi32>) -> tensor<2x2xf32> {
    %dst = tensor.reshape %src(%shape) : (tensor<4x1xf32>, tensor<2xi32>) -> tensor<2x2xf32>
    return %dst : tensor<2x2xf32>
  }

  func.func @main(
      %source: tensor<4x?x4xf32>, %dest: tensor<8x16x4xf32>, %o0: index, %o1: index, %o2: index, %sz1: index, %st1: index,
      %arg0: tensor<10xi32>,
      %src: tensor<4x1xf32>, %shape: tensor<2xi32>
  ) -> (tensor<8x16x4xf32>, tensor<18xi32>, tensor<2x2xf32>) {
    %inserted = call @insert_slice_into_tensor(%source, %dest, %o0, %o1, %o2, %sz1, %st1) : (tensor<4x?x4xf32>, tensor<8x16x4xf32>, index, index, index, index, index) -> tensor<8x16x4xf32>
    %padded = call @pad_tensor(%arg0) : (tensor<10xi32>) -> tensor<18xi32>
    %reshaped = call @reshape_tensor(%src, %shape) : (tensor<4x1xf32>, tensor<2xi32>) -> tensor<2x2xf32>
    return %inserted, %padded, %reshaped : tensor<8x16x4xf32>, tensor<18xi32>, tensor<2x2xf32>
  }
}