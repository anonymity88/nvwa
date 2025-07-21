module {
  func.func @create_empty_tensor(%dim1: index, %dim2: index) -> tensor<?x?xf32> {
    %empty_tensor = tensor.empty(%dim1, %dim2) : tensor<?x?xf32>
    return %empty_tensor : tensor<?x?xf32>
  }

  func.func @create_static_splat_tensor() -> tensor<8x16xf32> {
    %s = arith.constant 1.0 : f32
    %t = tensor.splat %s : tensor<8x16xf32>
    return %t : tensor<8x16xf32>
  }

  func.func @create_dynamic_splat_tensor(%m: index, %n: index) -> tensor<?x20x?xf32> {
    %s = arith.constant 1.0 : f32
    %t = tensor.splat %s[%m, %n] : tensor<?x20x?xf32>
    return %t : tensor<?x20x?xf32>
  }

  func.func @cast_tensor(%input: tensor<*xf32>) -> tensor<4x?xf32> {
    %casted_tensor = tensor.cast %input : tensor<*xf32> to tensor<4x?xf32>
    return %casted_tensor : tensor<4x?xf32>
  }

  func.func @main(%input: tensor<*xf32>, %dim1: index, %dim2: index, %m: index, %n: index) 
      -> (tensor<4x?xf32>, tensor<8x16xf32>, tensor<?x20x?xf32>, tensor<?x?xf32>) {
    %empty = call @create_empty_tensor(%dim1, %dim2) : (index, index) -> tensor<?x?xf32>
    %static_splat = call @create_static_splat_tensor() : () -> tensor<8x16xf32>
    %dynamic_splat = call @create_dynamic_splat_tensor(%m, %n) : (index, index) -> tensor<?x20x?xf32>
    %casted = call @cast_tensor(%input) : (tensor<*xf32>) -> tensor<4x?xf32>
    
    return %casted, %static_splat, %dynamic_splat, %empty : tensor<4x?xf32>, tensor<8x16xf32>, tensor<?x20x?xf32>, tensor<?x?xf32>
  }
}