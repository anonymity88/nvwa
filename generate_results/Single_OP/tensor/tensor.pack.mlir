module {
  func.func @main(%source: tensor<128x256xf32>, %pad: f32, %dest: tensor<256x128x16x32xf32>) -> tensor<256x128x16x32xf32> {
    %0 = tensor.pack %source 
        padding_value(%pad : f32) 
        outer_dims_perm = [1, 0] 
        inner_dims_pos = [0, 1] 
        inner_tiles = [16, 32] 
        into %dest : tensor<128x256xf32> -> tensor<256x128x16x32xf32>
    return %0 : tensor<256x128x16x32xf32>
  }
}