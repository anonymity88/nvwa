module {
  func.func @main() {
    // First part: vector store operations
    %base1 = memref.alloc() : memref<200x100xf32>
    %i1 = arith.constant 0 : index
    %j1 = arith.constant 0 : index
    %valueToStore = arith.constant dense<[[1.0, 2.0], [3.0, 4.0], [5.0, 6.0], [7.0, 8.0]]> : vector<4x2xf32>
    vector.store %valueToStore, %base1[%i1, %j1] : memref<200x100xf32>, vector<4x2xf32>

    // Second part: vector broadcast operations
    %scalar = arith.constant 1.0 : f32
    %broadcasted_vector_1 = vector.broadcast %scalar : f32 to vector<16xf32>
    %broadcasted_vector_2 = vector.broadcast %broadcasted_vector_1 : vector<16xf32> to vector<4x16xf32>

    // Third part: vector gather operations
    %base2 = memref.alloc() : memref<16x16xf32>
    %i2 = arith.constant 0 : index
    %j2 = arith.constant 0 : index
    %index_vec = arith.constant dense<[0, 1, 2, 3]> : vector<4xi32>
    %mask = arith.constant dense<[1, 0, 1, 1]> : vector<4xi1>
    %pass_thru = arith.constant dense<[10.0, 20.0, 30.0, 40.0]> : vector<4xf32>
    %result = vector.gather %base2[%i2, %j2][%index_vec], %mask, %pass_thru 
      : memref<16x16xf32>, vector<4xi32>, vector<4xi1>, vector<4xf32> into vector<4xf32>

    // Extract a value from the broadcasted vector
    %extracted_value = vector.extract %broadcasted_vector_2[0, 0] : f32 from vector<4x16xf32>

    // Create a scalable vector for the insert operation
    %scalable_vector = vector.broadcast %scalar : f32 to vector<[4]xf32>
    
    // Call the insert function with proper types
    %modified_vector = call @insert_scalar_into_vec_1d_f32_scalable(%extracted_value, %scalable_vector) : (f32, vector<[4]xf32>) -> vector<[4]xf32>

    return
  }

  func.func @insert_scalar_into_vec_1d_f32_scalable(%arg0: f32, %arg1: vector<[4]xf32>) -> vector<[4]xf32> {
    %0 = vector.insert %arg0, %arg1[3] : f32 into vector<[4]xf32>
    return %0 : vector<[4]xf32>
  }
}