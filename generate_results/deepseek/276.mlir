module {
  func.func @static_splat() -> tensor<8x16xf32> {
    %s = arith.constant 1.0 : f32
    %t = tensor.splat %s : tensor<8x16xf32>
    return %t : tensor<8x16xf32>
  }

  func.func @dynamic_splat(%m: index, %n: index) -> tensor<?x20x?xf32> {
    %s = arith.constant 1.0 : f32
    %t = tensor.splat %s[%m, %n] : tensor<?x20x?xf32>
    return %t : tensor<?x20x?xf32>
  }

  func.func @insert_slice_operation(%source: tensor<4x?x4xf32>, %dest: tensor<8x16x4xf32>, %o0: index, %o1: index, %o2: index, %sz1: index, %st1: index) -> tensor<8x16x4xf32> {
    %result = tensor.insert_slice %source into %dest[%o0, %o1, %o2][4, %sz1, 4][1, %st1, 1] : tensor<4x?x4xf32> into tensor<8x16x4xf32>
    return %result : tensor<8x16x4xf32>
  }

  func.func @create_from_elements(%a: index, %b: index, %c: index, %d: index, %e: index, %f: index) -> tensor<2x3xindex> {
    %result = tensor.from_elements %a, %b, %c, %d, %e, %f : tensor<2x3xindex>
    return %result : tensor<2x3xindex>
  }

  func.func @insert_slice_rank_reducing(%dst: tensor<128x128x128x128xf32>, %mid: tensor<1x16x1xf32>, %src: tensor<16xf32>, %offset: index) -> tensor<128x128x128x128xf32> {
    %0 = tensor.insert_slice %src into %mid[0, 0, 0] [1, 16, 1] [1, 1, 1] : tensor<16xf32> into tensor<1x16x1xf32>
    %1 = tensor.insert_slice %0 into %dst[6, 7, 8, %offset] [1, 1, 16, 1] [1, 1, 1, 1] : tensor<1x16x1xf32> into tensor<128x128x128x128xf32>
    return %1: tensor<128x128x128x128xf32>
  }

  func.func @main(%m: index, %n: index, %o0: index, %o1: index, %o2: index, %sz1: index, %st1: index, %a: index, %b: index, %c: index, %d: index, %e: index, %f: index, %dst: tensor<128x128x128x128xf32>, %mid: tensor<1x16x1xf32>, %src: tensor<16xf32>, %offset: index) -> (tensor<8x16xf32>, tensor<?x20x?xf32>, tensor<8x16x4xf32>, tensor<2x3xindex>, tensor<128x128x128x128xf32>) {
    %static_splat = call @static_splat() : () -> tensor<8x16xf32>
    
    %dynamic_splat = call @dynamic_splat(%m, %n) : (index, index) -> tensor<?x20x?xf32>
    
    %dest_init = tensor.empty() : tensor<8x16x4xf32>
    
    %source = tensor.empty(%sz1) : tensor<4x?x4xf32>
    
    %inserted = call @insert_slice_operation(%source, %dest_init, %o0, %o1, %o2, %sz1, %st1) : (tensor<4x?x4xf32>, tensor<8x16x4xf32>, index, index, index, index, index) -> tensor<8x16x4xf32>
    
    %elements_tensor = call @create_from_elements(%a, %b, %c, %d, %e, %f) : (index, index, index, index, index, index) -> tensor<2x3xindex>
    
    %rank_reduced = call @insert_slice_rank_reducing(%dst, %mid, %src, %offset) : (tensor<128x128x128x128xf32>, tensor<1x16x1xf32>, tensor<16xf32>, index) -> tensor<128x128x128x128xf32>
    
    return %static_splat, %dynamic_splat, %inserted, %elements_tensor, %rank_reduced : tensor<8x16xf32>, tensor<?x20x?xf32>, tensor<8x16x4xf32>, tensor<2x3xindex>, tensor<128x128x128x128xf32>
  }
}