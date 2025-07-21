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

  func.func @no_sliced_linearized_dims(%input: tensor<30x11x100xf32>, %offt: index, %size: index) -> tensor<330x?xf32> {
    %collapsed = tensor.collapse_shape %input [[0, 1], [2]] : tensor<30x11x100xf32> into tensor<330x100xf32>
    %slice = tensor.extract_slice %collapsed [0, %offt] [330, %size] [1, 1] : tensor<330x100xf32> to tensor<330x?xf32>
    return %slice : tensor<330x?xf32>
  }

  func.func @main(%input: tensor<*xf32>, %dim1: index, %dim2: index, %m: index, %n: index, %input_slice: tensor<30x11x100xf32>, %offt: index, %size: index) 
      -> (tensor<4x?xf32>, tensor<8x16xf32>, tensor<?x20x?xf32>, tensor<?x?xf32>, tensor<330x?xf32>) {
    %empty = call @create_empty_tensor(%dim1, %dim2) : (index, index) -> tensor<?x?xf32>
    %static_splat = call @create_static_splat_tensor() : () -> tensor<8x16xf32>
    %dynamic_splat = call @create_dynamic_splat_tensor(%m, %n) : (index, index) -> tensor<?x20x?xf32>
    %casted = call @cast_tensor(%input) : (tensor<*xf32>) -> tensor<4x?xf32>
    %sliced = call @no_sliced_linearized_dims(%input_slice, %offt, %size) : (tensor<30x11x100xf32>, index, index) -> tensor<330x?xf32>
    
    return %casted, %static_splat, %dynamic_splat, %empty, %sliced : tensor<4x?xf32>, tensor<8x16xf32>, tensor<?x20x?xf32>, tensor<?x?xf32>, tensor<330x?xf32>
  }
}