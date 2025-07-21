#reverse_trait = {
  indexing_maps = [
          affine_map<(i) -> (3 - i)>,
          affine_map<(i) -> (i)>
  ],
  iterator_types = ["parallel"]
}

module {
  func.func @generate_tensor(%m: index, %n: index) -> tensor<?x?xf32> {
    %tnsr = tensor.generate %m, %n {
    ^bb0(%i: index, %j: index):
      %val1 = arith.constant 0.0 : f32
      %val2 = arith.constant 1.0 : f32
      %elem = arith.addf %val1, %val2 : f32
      tensor.yield %elem : f32
    } : tensor<?x?xf32>
    return %tnsr : tensor<?x?xf32>
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

  func.func @scatter_tensor(%source: tensor<1x2xf32>, %dest: tensor<4x4x4xf32>, %indices: tensor<1x2x3xi32>) -> tensor<4x4x4xf32> {
    %out = tensor.scatter %source into %dest[%indices] scatter_dims([0, 1, 2]) unique : 
      (tensor<1x2xf32>, tensor<4x4x4xf32>, tensor<1x2x3xi32>) -> tensor<4x4x4xf32>
    return %out : tensor<4x4x4xf32>
  }

  func.func @reverse_from_3(%arg0: tensor<?xf32>) -> (tensor<?xf32>) {
    %cf0 = arith.constant 0.0 : f32 
    %ci0 = arith.constant 0 : index 
    %d0 = tensor.dim %arg0, %ci0 : tensor<?xf32>
    %splat = tensor.splat %cf0[%d0] : tensor<?xf32>
    %result = linalg.generic #reverse_trait ins(%arg0: tensor<?xf32>) outs(%splat: tensor<?xf32>) {
      ^bb0(%a: f32, %b: f32):
      linalg.yield %a : f32
    } -> tensor<?xf32>
    return %result : tensor<?xf32>
  }

  func.func @main(%source: tensor<1x2xf32>, %dest: tensor<4x4x4xf32>, %indices: tensor<1x2x3xi32>, %m1: index, %n1: index, %m2: index, %n2: index, %input_reverse: tensor<?xf32>) -> (tensor<8x16xf32>, tensor<?x20x?xf32>, tensor<?x?xf32>, tensor<4x4x4xf32>, tensor<?xf32>) {
    %static_splat = call @create_static_splat_tensor() : () -> tensor<8x16xf32>
    %dynamic_splat = call @create_dynamic_splat_tensor(%m1, %n1) : (index, index) -> tensor<?x20x?xf32>
    %generated_tensor = call @generate_tensor(%m2, %n2) : (index, index) -> tensor<?x?xf32>
    %scattered_tensor = call @scatter_tensor(%source, %dest, %indices) : (tensor<1x2xf32>, tensor<4x4x4xf32>, tensor<1x2x3xi32>) -> tensor<4x4x4xf32>
    %reversed_tensor = call @reverse_from_3(%input_reverse) : (tensor<?xf32>) -> tensor<?xf32>
    return %static_splat, %dynamic_splat, %generated_tensor, %scattered_tensor, %reversed_tensor : tensor<8x16xf32>, tensor<?x20x?xf32>, tensor<?x?xf32>, tensor<4x4x4xf32>, tensor<?xf32>
  }
}