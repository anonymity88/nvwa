module {
  func.func @main() {
    // Initialize constants for vector operations
    %c5_i32 = arith.constant 5 : i32
    %c3_i32 = arith.constant 3 : i32
    %c2_5_f32 = arith.constant 2.5 : f32
    %c1_5_f32 = arith.constant 1.5 : f32
    %true = arith.constant true
    %false = arith.constant false

    // Create vectors for the combined_operations function
    %src1_i32 = vector.broadcast %c5_i32 : i32 to vector<[4]xi32>
    %src2_i32 = vector.broadcast %c3_i32 : i32 to vector<[4]xi32>
    %src1_f32 = vector.broadcast %c2_5_f32 : f32 to vector<[4]xf32>
    %src2_f32 = vector.broadcast %c1_5_f32 : f32 to vector<[4]xf32>
    %mask_i32 = vector.broadcast %true : i1 to vector<[4]xi1>
    %mask_f32 = vector.broadcast %false : i1 to vector<[4]xi1>

    // Call combined vector operations
    %divi_result, %subf_result, %addi_result = call @combined_operations(
        %mask_i32, %src1_i32, %src2_i32,
        %mask_f32, %src1_f32, %src2_f32
    ) : (vector<[4]xi1>, vector<[4]xi32>, vector<[4]xi32>,
         vector<[4]xi1>, vector<[4]xf32>, vector<[4]xf32>
        ) -> (vector<[4]xi32>, vector<[4]xf32>, vector<[4]xi32>)

    // Allocate memrefs for conv3d operation
    %c8 = arith.constant 8 : index
    %in = memref.alloc(%c8, %c8, %c8) : memref<?x?x?xf32>
    %filter = memref.alloc(%c8, %c8, %c8) : memref<?x?x?xf32>
    %out = memref.alloc(%c8, %c8, %c8) : memref<?x?x?xf32>

    // Call conv3d operation
    call @conv3d_no_symbols(%in, %filter, %out) : (memref<?x?x?xf32>, memref<?x?x?xf32>, memref<?x?x?xf32>) -> ()

    return
  }

  func.func @combined_operations(
      %mask_i32: vector<[4]xi1>, %src1_i32: vector<[4]xi32>, %src2_i32: vector<[4]xi32>,
      %mask_f32: vector<[4]xi1>, %src1_f32: vector<[4]xf32>, %src2_f32: vector<[4]xf32>
  ) -> (vector<[4]xi32>, vector<[4]xf32>, vector<[4]xi32>) {
    %result_divi = arm_sve.masked.divi_signed %mask_i32, %src1_i32, %src2_i32 : vector<[4]xi1>, vector<[4]xi32>
    %result_subf = arm_sve.masked.subf %mask_f32, %src1_f32, %src2_f32 : vector<[4]xi1>, vector<[4]xf32>
    %result_addi = arm_sve.masked.addi %mask_i32, %src1_i32, %src2_i32 : vector<[4]xi1>, vector<[4]xi32>
    return %result_divi, %result_subf, %result_addi : vector<[4]xi32>, vector<[4]xf32>, vector<[4]xi32>
  }

  func.func @conv3d_no_symbols(%in : memref<?x?x?xf32>, %filter : memref<?x?x?xf32>, %out : memref<?x?x?xf32>) -> () {
    linalg.conv_3d ins(%in, %filter : memref<?x?x?xf32>, memref<?x?x?xf32>)
                  outs(%out : memref<?x?x?xf32>)
    return
  }
}