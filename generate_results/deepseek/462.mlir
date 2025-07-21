module {
  // Define the main function that calls both ptr_test functions
  func.func @main(%arg0: !ptr.ptr, %arg1: !ptr.ptr<1 : i32>, %arg2: memref<!ptr.ptr>) {
    // Call the first ptr_test function with pointer arguments
    %result0, %result1 = call @ptr_test_pointer(%arg0, %arg1) : (!ptr.ptr, !ptr.ptr<1 : i32>) -> (!ptr.ptr<1 : i32>, !ptr.ptr)
    
    // Call the second ptr_test function with memref argument
    call @ptr_test_memref(%arg2) : (memref<!ptr.ptr>) -> ()
    
    return
  }

  // Define the first ptr_test function with pointer arguments
  func.func @ptr_test_pointer(%arg0: !ptr.ptr, %arg1: !ptr.ptr<1 : i32>) -> (!ptr.ptr<1 : i32>, !ptr.ptr) {
    return %arg1, %arg0 : !ptr.ptr<1 : i32>, !ptr.ptr
  }

  // Define the second ptr_test function with memref argument
  func.func @ptr_test_memref(%arg0: memref<!ptr.ptr>) {
    return
  }
}