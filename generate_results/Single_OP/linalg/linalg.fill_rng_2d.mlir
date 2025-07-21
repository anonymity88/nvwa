func.func @generalize_index(%min: f64, %max: f64, %seed: i32, %O: tensor<16x32xf32>) -> tensor<16x32xf32> {
  %0 = linalg.fill_rng_2d ins(%min, %max, %seed: f64, f64, i32) outs(%O : tensor<16x32xf32>) -> tensor<16x32xf32>
  return %0: tensor<16x32xf32>
}