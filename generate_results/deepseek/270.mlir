module {
  func.func @combined_masked_operations(
    %mask_i32: vector<[4]xi1>,
    %src1_i32: vector<[4]xi32>,
    %src2_i32: vector<[4]xi32>,
    %mask_f32: vector<[4]xi1>,
    %src1_f32: vector<[4]xf32>,
    %src2_f32: vector<[4]xf32>
  ) -> (vector<[4]xi32>, vector<[4]xi32>, vector<[4]xf32>) {
    %add_result = arm_sve.masked.addi %mask_i32, %src1_i32, %src2_i32 : vector<[4]xi1>, vector<[4]xi32>
    %div_result = arm_sve.masked.divi_signed %mask_i32, %src1_i32, %src2_i32 : vector<[4]xi1>, vector<[4]xi32>
    %mul_result = arm_sve.masked.mulf %mask_f32, %src1_f32, %src2_f32 : vector<[4]xi1>, vector<[4]xf32>
    return %add_result, %div_result, %mul_result : 
      vector<[4]xi32>, vector<[4]xi32>, vector<[4]xf32>
  }

  func.func @main() -> (vector<[4]xi32>, vector<[4]xi32>, vector<[4]xf32>, tensor<5xf32>) {
    // Create some dummy inputs for the masked operations
    %mask_i32 = "test.create_vector"() : () -> vector<[4]xi1>
    %src1_i32 = "test.create_vector"() : () -> vector<[4]xi32>
    %src2_i32 = "test.create_vector"() : () -> vector<[4]xi32>
    %mask_f32 = "test.create_vector"() : () -> vector<[4]xi1>
    %src1_f32 = "test.create_vector"() : () -> vector<[4]xf32>
    %src2_f32 = "test.create_vector"() : () -> vector<[4]xf32>

    // Call the combined masked operations
    %0:3 = call @combined_masked_operations(
      %mask_i32, %src1_i32, %src2_i32, 
      %mask_f32, %src1_f32, %src2_f32
    ) : (
      vector<[4]xi1>, vector<[4]xi32>, vector<[4]xi32>,
      vector<[4]xi1>, vector<[4]xf32>, vector<[4]xf32>
    ) -> (vector<[4]xi32>, vector<[4]xi32>, vector<[4]xf32>)

    // Call the dialect conversion function
    %1 = call @full_dialect_conversion() : () -> tensor<5xf32>

    return %0#0, %0#1, %0#2, %1 : 
      vector<[4]xi32>, vector<[4]xi32>, vector<[4]xf32>, tensor<5xf32>
  }

  func.func @full_dialect_conversion() -> tensor<5xf32> {
    %0 = "test.foo"() {replace_with_new_op = "test.bar"} : () -> (tensor<5xf32>)
    return %0 : tensor<5xf32>
  }
}