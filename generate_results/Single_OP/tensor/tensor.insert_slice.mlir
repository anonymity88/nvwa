module {
  func.func @main(%source: tensor<4x?x4xf32>, %dest: tensor<8x16x4xf32>, %o0: index, %o1: index, %o2: index, %sz1: index, %st1: index) -> tensor<8x16x4xf32> {
    %result = tensor.insert_slice %source into %dest[%o0, %o1, %o2][4, %sz1, 4][1, %st1, 1] : tensor<4x?x4xf32> into tensor<8x16x4xf32>
    return %result : tensor<8x16x4xf32>
  }
}