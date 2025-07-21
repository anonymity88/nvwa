module {
  func.func @extract_element_from_tensor(%t: tensor<4x4xi32>, %i: index, %j: index) -> i32 {
    %element = tensor.extract %t[%i, %j] : tensor<4x4xi32>
    return %element : i32
  }

  func.func @pad_tensor(%arg0: tensor<10xi32>) -> tensor<18xi32> {
    %c0_i32 = arith.constant 0 : i32
    %padded = tensor.pad %arg0 low[3] high[5] {
      ^bb0(%arg1: index):
        tensor.yield %c0_i32 : i32
    } : tensor<10xi32> to tensor<18xi32>
    return %padded : tensor<18xi32>
  }

  func.func @insert_slice_into_tensor(%source: tensor<4x?x4xf32>, %dest: tensor<8x16x4xf32>, %o0: index, %o1: index, %o2: index, %sz1: index, %st1: index) -> tensor<8x16x4xf32> {
    %result = tensor.insert_slice %source into %dest[%o0, %o1, %o2][4, %sz1, 4][1, %st1, 1] : tensor<4x?x4xf32> into tensor<8x16x4xf32>
    return %result : tensor<8x16x4xf32>
  }

  func.func @main(
      %source: tensor<4x?x4xf32>, %dest: tensor<8x16x4xf32>, %o0: index, %o1: index, %o2: index, %sz1: index, %st1: index,
      %arg0: tensor<10xi32>,
      %t: tensor<4x4xi32>, %i: index, %j: index
  ) -> (tensor<8x16x4xf32>, tensor<18xi32>, i32) {
    %extracted_element = call @extract_element_from_tensor(%t, %i, %j) : (tensor<4x4xi32>, index, index) -> i32
    %padded_tensor = call @pad_tensor(%arg0) : (tensor<10xi32>) -> tensor<18xi32>
    %result_tensor = call @insert_slice_into_tensor(%source, %dest, %o0, %o1, %o2, %sz1, %st1) : (tensor<4x?x4xf32>, tensor<8x16x4xf32>, index, index, index, index, index) -> tensor<8x16x4xf32>
    return %result_tensor, %padded_tensor, %extracted_element : tensor<8x16x4xf32>, tensor<18xi32>, i32
  }
}