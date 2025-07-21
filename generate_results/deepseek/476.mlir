#SV = #sparse_tensor.encoding<{ map = (d0) -> (d0 : compressed) }>
#SpVec = #sparse_tensor.encoding<{ map = (d0) -> (d0 : compressed) }>
#CSR = #sparse_tensor.encoding<{ map = (d0, d1) -> (d0 : dense, d1 : compressed) }>
#Row = #sparse_tensor.encoding<{ map = (d0, d1) -> (d0 : compressed, d1 : dense) }>
#EncDenseVec = #sparse_tensor.encoding<{ map = (d0) -> (d0 : dense) }>

#trait = {
  indexing_maps = [
    affine_map<(i) -> (i)>,  // A (in)
    affine_map<(i) -> (i)>   // X (out)
  ],
  iterator_types = ["parallel"]
}

#trait1 = {
  indexing_maps = [
    affine_map<(i) -> (i)>,  // a
    affine_map<(i) -> (3)>,  // b
    affine_map<(i) -> (i)>   // x (out)
  ],
  iterator_types = ["parallel"],
  doc = "x(i) += a(i) * b(3)"
}

module {
  func.func @main(%arga: tensor<10xi32, #SV>, 
                  %argb: tensor<10xf32>,
                  %argc: tensor<32xf32, #SpVec>,
                  %argd: tensor<4xf32>,
                  %arge: tensor<32xf32>) -> (tensor<10xf32>, tensor<32xf32>) {
    %0 = call @allout_inplace(%arga, %argb) : (tensor<10xi32, #SV>, tensor<10xf32>) -> tensor<10xf32>
    %1 = call @mul_inv_dense1d(%argc, %argd, %arge) : (tensor<32xf32, #SpVec>, tensor<4xf32>, tensor<32xf32>) -> tensor<32xf32>
    return %0, %1 : tensor<10xf32>, tensor<32xf32>
  }

  func.func @allout_inplace(%arga: tensor<10xi32, #SV>,
                           %argb: tensor<10xf32>) -> tensor<10xf32> {
    %0 = linalg.generic #trait
      ins(%arga: tensor<10xi32, #SV>)
      outs(%argb: tensor<10xf32>) {
      ^bb(%a: i32, %x : f32):
        %cst = arith.sitofp %a : i32 to f32
        linalg.yield %cst : f32
    } -> tensor<10xf32>
    return %0 : tensor<10xf32>
  }

  func.func @mul_inv_dense1d(%arga: tensor<32xf32, #SpVec>,
                            %argb: tensor<4xf32>,
                            %argx: tensor<32xf32>) -> tensor<32xf32> {
    %0 = linalg.generic #trait1
      ins(%arga, %argb: tensor<32xf32, #SpVec>, tensor<4xf32>)
      outs(%argx: tensor<32xf32>) {
      ^bb(%a: f32, %b: f32, %x: f32):
        %0 = arith.mulf %a, %b : f32
        %1 = arith.addf %x, %0 : f32
        linalg.yield %1 : f32
    } -> tensor<32xf32>
    return %0 : tensor<32xf32>
  }
}