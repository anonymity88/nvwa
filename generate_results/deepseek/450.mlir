module {
  func.func @main() -> !mpi.retval {
    // Initialize MPI
    "mpi.init"() : () -> ()
    
    // First set of operations from first IR fragment (receive operations)
    %recv_buffer = memref.alloc() : memref<1024xi32>
    %recv_tag = arith.constant 0 : i32
    %recv_rank = arith.constant 0 : i32
    %recv_retval = "mpi.recv"(%recv_buffer, %recv_tag, %recv_rank) : (memref<1024xi32>, i32, i32) -> !mpi.retval
    %recv_errclass = "mpi.error_class"(%recv_retval) : (!mpi.retval) -> !mpi.retval
    
    // Second set of operations from second IR fragment (send operations)
    %send_buffer = memref.alloc() : memref<1024xi32>
    %send_tag = arith.constant 42 : i32
    %send_rank = arith.constant 1 : i32
    %send_retval = "mpi.send"(%send_buffer, %send_tag, %send_rank) : (memref<1024xi32>, i32, i32) -> !mpi.retval
    %send_errclass = "mpi.error_class"(%send_retval) : (!mpi.retval) -> !mpi.retval
    
    // Finalize MPI (from first fragment)
    "mpi.finalize"() : () -> ()
    
    // Return the last error class result (from send operation)
    return %send_errclass : !mpi.retval
  }
}