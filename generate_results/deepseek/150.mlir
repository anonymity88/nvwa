module {
  func.func @main() -> !mpi.retval {
    // Initialize MPI
    "mpi.init"() : () -> ()
    
    // Get current process rank
    %comm_rank_retval, %rank = "mpi.comm_rank"() : () -> (!mpi.retval, i32)
    
    // Check for errors in comm_rank operation
    %rank_errclass = "mpi.error_class"(%comm_rank_retval) : (!mpi.retval) -> !mpi.retval
    
    // Allocate buffer for sending data
    %buffer = memref.alloc() : memref<1024xi32>
    
    // Define tag for communication
    %tag = arith.constant 42 : i32
    
    // Send data (using rank 1 as destination)
    %send_retval = "mpi.send"(%buffer, %tag, %rank) : (memref<1024xi32>, i32, i32) -> !mpi.retval
    
    // Check for errors in send operation
    %send_errclass = "mpi.error_class"(%send_retval) : (!mpi.retval) -> !mpi.retval
    
    // Finalize MPI
    "mpi.finalize"() : () -> ()
    
    // Return the last error class (from send operation)
    return %send_errclass : !mpi.retval
  }
}