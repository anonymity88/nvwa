module {
  func.func @bitcast_tensor(%src: tensor<4xui32>) -> tensor<4xi32> {
    %bitcasted_tensor = tensor.bitcast %src : tensor<4xui32> to tensor<4xi32>
    return %bitcasted_tensor : tensor<4xi32>
  }

  func.func @extract_slices(%arg: tensor<8x16x4xf32>, %offset0: index, %offset2: index, %size1: index, %stride1: index) -> (tensor<16x4xf32>, tensor<1x?xf32>) {
    %slice1 = tensor.extract_slice %arg[0, 0, 0][1, 16, 4][1, 1, 1] : tensor<8x16x4xf32> to tensor<16x4xf32>
    %slice2 = tensor.extract_slice %arg[%offset0, 4, %offset2][1, %size1, 1][1, %stride1, 1] : tensor<8x16x4xf32> to tensor<1x?xf32>
    return %slice1, %slice2 : tensor<16x4xf32>, tensor<1x?xf32>
  }

  func.func @pack_tensor(%source: tensor<128x256xf32>, %pad: f32, %dest: tensor<256x128x16x32xf32>) -> tensor<256x128x16x32xf32> {
    %0 = tensor.pack %source 
        padding_value(%pad : f32) 
        outer_dims_perm = [1, 0] 
        inner_dims_pos = [0, 1] 
        inner_tiles = [16, 32] 
        into %dest : tensor<128x256xf32> -> tensor<256x128x16x32xf32>
    return %0 : tensor<256x128x16x32xf32>
  }

  func.func @insert_slice_unit_dims(%arg0: tensor<1x3xf32>, %arg1: tensor<1x1xf32>) -> tensor<1x3xf32> {
    %0 = tensor.insert_slice %arg1 into %arg0[0, 2] [1, 1] [1, 1] : tensor<1x1xf32> into tensor<1x3xf32>
    return %0 : tensor<1x3xf32>
  }

  func.func @main(
      %src: tensor<4xui32>,
      %arg: tensor<8x16x4xf32>, 
      %offset0: index, 
      %offset2: index, 
      %size1: index, 
      %stride1: index,
      %source: tensor<128x256xf32>, 
      %pad: f32, 
      %dest: tensor<256x128x16x32xf32>,
      %slice_src: tensor<1x3xf32>,
      %slice_val: tensor<1x1xf32>
  ) -> (tensor<4xi32>, tensor<16x4xf32>, tensor<1x?xf32>, tensor<256x128x16x32xf32>, tensor<1x3xf32>) {
    %bitcasted = call @bitcast_tensor(%src) : (tensor<4xui32>) -> tensor<4xi32>
    %slice1, %slice2 = call @extract_slices(%arg, %offset0, %offset2, %size1, %stride1) : 
        (tensor<8x16x4xf32>, index, index, index, index) -> (tensor<16x4xf32>, tensor<1x?xf32>)
    %packed = call @pack_tensor(%source, %pad, %dest) : 
        (tensor<128x256xf32>, f32, tensor<256x128x16x32xf32>) -> tensor<256x128x16x32xf32>
    %inserted = call @insert_slice_unit_dims(%slice_src, %slice_val) : (tensor<1x3xf32>, tensor<1x1xf32>) -> tensor<1x3xf32>
    return %bitcasted, %slice1, %slice2, %packed, %inserted : tensor<4xi32>, tensor<16x4xf32>, tensor<1x?xf32>, tensor<256x128x16x32xf32>, tensor<1x3xf32>
  }
}