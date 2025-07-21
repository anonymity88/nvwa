module {
  func.func @main(%arg: memref<4x4xf32>) -> () {
    // Extract the underlying aligned pointer as an index
    %aligned_pointer = memref.extract_aligned_pointer_as_index %arg : memref<4x4xf32> -> index
    
    // Cast the index to a 64-bit integer
    %index_as_i64 = arith.index_cast %aligned_pointer : index to i64
    
    // Convert the i64 index to a pointer type
    %pointer = llvm.inttoptr %index_as_i64 : i64 to !llvm.ptr
    
    // Here you could call a function using the pointer, for example:
    // call @foo(%pointer) : (!llvm.ptr) -> ()
    
    return
  }
}