module {
  func.func @main() -> () {
    %0 = tensor.load %arg0[%c0] : memref<?xf32>
    %1 = tensor.extract_slice %0[0] : memref<?xf32> -> vector<4xf32>
    %2 = vector.transfer_read %1[0, 0] : memref<?xf32>, vector<4xf32>
    %3 = vector.transfer_write %2, %arg1[%c0, %c1] : vector<4xf32> to memref<?xf32>
    %4 = tensor.insert_slice %3 into %arg1[0] : vector<4xf32> into memref<?xf32>
    
    "transform.apply_patterns.tensor.fold_tensor_subset_ops_into_vector_transfers"() {
      // Indicate transformation patterns here
      // tensor.extract_slice -> vector.transfer_read
      // vector.transfer_write -> tensor.insert_slice
    } : () -> ()
    
    return
  }
}