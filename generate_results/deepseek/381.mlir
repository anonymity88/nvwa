#map_src = affine_map<(d0, d1) -> (d0 + 3, d1)>
#map_dst = affine_map<(d0, d1) -> (d0 + 7, d1)>
#map_tag = affine_map<(d0) -> (d0)>
#map_prefetch = affine_map<(d0, d1) -> (d0, d1)>
#map_lower = affine_map<()[s0] -> (s0)>
#map_upper = affine_map<()[s0] -> (s0 + 98)>
#map_inner_lower = affine_map<()[s0, s1] -> (s0)>
#map_inner_upper = affine_map<()[s0, s1] -> (s0 + 2)>

module {
  func.func @main(%dim: index) -> () {
    %src = memref.alloca() : memref<40x128xf32, 0>
    %dst = memref.alloca() : memref<2x1024xf32, 1>
    %tag = memref.alloca() : memref<1xi32, 2>
    %num_elements = arith.constant 256 : index
    %idx = arith.constant 0 : index
    
    %mem = memref.alloca() : memref<400x400xi32>
    %D = memref.alloca() : memref<100x100xf32>
    %K = memref.alloca() : memref<3x3xf32>
    
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    
    %i_dma = arith.index_cast %c0 : i32 to index
    %j_dma = arith.index_cast %c1 : i32 to index
    
    %i_prefetch = arith.index_cast %c0 : i32 to index
    %j_prefetch = arith.index_cast %c1 : i32 to index
    
    affine.dma_start %src[%i_dma + 3, %j_dma], %dst[%i_dma + 7, %j_dma], %tag[%idx], %num_elements : 
      memref<40x128xf32, 0>, memref<2x1024xf32, 1>, memref<1xi32, 2>
    
    affine.prefetch %mem[%i_prefetch, %j_prefetch + 5], read, locality<3>, data : memref<400x400xi32>
    
    %conv_result = func.call @conv_2d(%D, %K) : (memref<100x100xf32>, memref<3x3xf32>) -> memref<98x98xf32>
    
    %lb0 = arith.constant 0 : index
    %ub0 = arith.constant 100 : index
    %step0 = arith.constant 1 : index
    %ub2 = arith.constant 10 : index
    
    %t1 = tensor.empty(%dim) : tensor<1x?xi8>
    %t2 = tensor.empty(%dim, %dim) : tensor<?x?xi8>
    %t3 = tensor.empty(%dim) : tensor<1x?xi32>
    
    call @reify_slice_bound2(%lb0, %ub0, %step0, %ub2, %t1, %t2, %t3) : (index, index, index, index, tensor<1x?xi8>, tensor<?x?xi8>, tensor<1x?xi32>) -> ()
    
    return
  }
  
  func.func @conv_2d(%D : memref<100x100xf32>, %K : memref<3x3xf32>) -> (memref<98x98xf32>) {
    %O = memref.alloca() : memref<98x98xf32>
    
    affine.parallel (%x, %y) = (0, 0) to (98, 98) {
      %0 = affine.parallel (%kx, %ky) = (0, 0) to (2, 2) reduce ("addf") -> f32 {
        %1 = affine.load %D[%x + %kx, %y + %ky] : memref<100x100xf32>
        %2 = affine.load %K[%kx, %ky] : memref<3x3xf32>
        %3 = arith.mulf %1, %2 : f32
        affine.yield %3 : f32
      }
      affine.store %0, %O[%x, %y] : memref<98x98xf32>
    }
    
    return %O : memref<98x98xf32>
  }

  func.func @reify_slice_bound2(%lb0: index, %ub0: index, %step0: index,
                              %ub2: index, %t1: tensor<1x?xi8>,
                              %t2: tensor<?x?xi8>, %t3: tensor<1x?xi32>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c32 = arith.constant 32 : index
    scf.for %iv0 = %lb0 to %ub0 step %step0 {
      %ub1 = affine.min affine_map<(d0)[s0] -> (-d0 + s0, 128)>(%iv0)[%ub0]
      %ub1_ub = "test.reify_bound"(%ub1) {type = "UB"} : (index) -> (index)
      "test.some_use"(%ub1_ub) : (index) -> ()
      %lb1 = affine.apply affine_map<()[s0] -> ((s0 floordiv 32) * 32)>()[%ub1]
      %lb1_ub = "test.reify_bound"(%lb1) {type = "UB"} : (index) -> (index)
      "test.some_use"(%lb1_ub) : (index) -> ()
      %lb1_ub_const = "test.reify_bound"(%lb1) {type = "UB", constant} : (index) -> (index)
      "test.some_use"(%lb1_ub_const) : (index) -> ()
      scf.for %iv1 = %lb1 to %ub1 step %c32 {
        %sz = affine.apply affine_map<(d0)[s0] -> (-d0 + s0)>(%iv1)[%ub1]
        %sz_ub = "test.reify_bound"(%sz) {type = "UB"} : (index) -> (index)
        "test.some_use"(%sz_ub) : (index) -> ()
        scf.for %iv2 = %c0 to %ub2 step %c1 {
          %slice1 = tensor.extract_slice %t1[0, %iv2] [1, 1] [1, 1] : tensor<1x?xi8> to tensor<1x1xi8>
          %slice2 = tensor.extract_slice %t2[%iv2, 0] [1, %sz] [1, 1] : tensor<?x?xi8> to tensor<1x?xi8>
          %slice3 = tensor.extract_slice %t3[0, 0] [1, %sz] [1, 1] : tensor<1x?xi32> to tensor<1x?xi32>
          %matmul = linalg.matmul ins(%slice1, %slice2 : tensor<1x1xi8>, tensor<1x?xi8>) outs(%slice3 : tensor<1x?xi32>) -> tensor<1x?xi32>
          %matmul_ub = "test.reify_bound"(%matmul) {dim = 1, type = "UB"} : (tensor<1x?xi32>) -> (index)
          "test.some_use"(%matmul_ub) : (index) -> ()
          %matmul_ub_const = "test.reify_bound"(%matmul) {dim = 1, type = "UB", constant} : (tensor<1x?xi32>) -> (index)
          "test.some_use"(%matmul_ub_const) : (index) -> ()
        }
      }
    }
    return
  }
}