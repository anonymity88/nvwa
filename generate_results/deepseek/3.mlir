#map_src = affine_map<(d0, d1) -> (d0 + 3, d1)>
#map_dst = affine_map<(d0, d1) -> (d0 + 7, d1)>
#map_tag = affine_map<(d0) -> (d0)>
#map_prefetch = affine_map<(d0, d1) -> (d0, d1)>
#map_lower = affine_map<()[s0] -> (s0)>
#map_upper = affine_map<()[s0] -> (s0 + 98)>
#map_inner_lower = affine_map<()[s0, s1] -> (s0)>
#map_inner_upper = affine_map<()[s0, s1] -> (s0 + 2)>

module {
  func.func @main() -> () {
    // Allocate memory for various operations
    %src = memref.alloca() : memref<40x128xf32, 0>
    %dst = memref.alloca() : memref<2x1024xf32, 1>
    %tag = memref.alloca() : memref<1xi32, 2>
    %num_elements = arith.constant 256 : index
    %idx = arith.constant 0 : index
    
    %mem = memref.alloca() : memref<400x400xi32>
    %D = memref.alloca() : memref<100x100xf32>
    %K = memref.alloca() : memref<3x3xf32>
    
    // Constants for indexing
    %c0 = arith.constant 0 : i32
    %c1 = arith.constant 1 : i32
    
    // DMA operation setup
    %i_dma = arith.index_cast %c0 : i32 to index
    %j_dma = arith.index_cast %c1 : i32 to index
    
    // Prefetch operation setup
    %i_prefetch = arith.index_cast %c0 : i32 to index
    %j_prefetch = arith.index_cast %c1 : i32 to index
    
    // Execute DMA operation
    affine.dma_start %src[%i_dma + 3, %j_dma], %dst[%i_dma + 7, %j_dma], %tag[%idx], %num_elements : 
      memref<40x128xf32, 0>, memref<2x1024xf32, 1>, memref<1xi32, 2>
    
    // Execute prefetch operation
    affine.prefetch %mem[%i_prefetch, %j_prefetch + 5], read, locality<3>, data : memref<400x400xi32>
    
    // Call convolution function
    %conv_result = func.call @conv_2d(%D, %K) : (memref<100x100xf32>, memref<3x3xf32>) -> memref<98x98xf32>
    
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
}