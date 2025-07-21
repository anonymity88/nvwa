module {
  func.func @main() {
    // Define a constant value to initialize the mma_matrix
    %val_f16 = arith.constant 1.0 : f16
    %val_f32 = arith.constant 2.0 : f32

    // Create a constant matrix of 16x16 of f16 type
    %matrix_a = gpu.subgroup_mma_constant_matrix %val_f16 :
      !gpu.mma_matrix<16x16xf16, "AOp">

    // Create a constant matrix of 16x16 of f32 type
    %matrix_b = gpu.subgroup_mma_constant_matrix %val_f32 :
      !gpu.mma_matrix<16x16xf32, "COp">

    return
  }
}