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

  func.func @main(%m: index, %n: index, %o0: index, %o1: index, %o2: index, %sz1: index, %st1: index, %a: index, %b: index, %c: index, %d: index, %e: index, %f: index) -> (tensor<8x16xf32>, tensor<?x20x?xf32>, tensor<8x16x4xf32>, tensor<2x3xindex>) {
    // Get static splat tensor
    %static_splat = call @static_splat() : () -> tensor<8x16xf32>
    
    // Get dynamic splat tensor
    %dynamic_splat = call @dynamic_splat(%m, %n) : (index, index) -> tensor<?x20x?xf32>
    
    // Create a compatible destination tensor for insert_slice
    %dest_init = tensor.empty() : tensor<8x16x4xf32>
    
    // Create a source tensor for insert_slice
    %source = tensor.empty(%sz1) : tensor<4x?x4xf32>
    
    // Perform insert_slice operation
    %inserted = call @insert_slice_operation(%source, %dest_init, %o0, %o1, %o2, %sz1, %st1) : (tensor<4x?x4xf32>, tensor<8x16x4xf32>, index, index, index, index, index) -> tensor<8x16x4xf32>
    
    // Create from_elements tensor
    %elements_tensor = call @create_from_elements(%a, %b, %c, %d, %e, %f) : (index, index, index, index, index, index) -> tensor<2x3xindex>
    
    return %static_splat, %dynamic_splat, %inserted, %elements_tensor : tensor<8x16xf32>, tensor<?x20x?xf32>, tensor<8x16x4xf32>, tensor<2x3xindex>
  }
}