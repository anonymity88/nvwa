module {
  func.func @main() -> !mpi.retval {
    // Initialize MPI
    "mpi.init"() : () -> ()
    
    // First set of operations from first IR fragment
    %comm_rank_retval, %rank = "mpi.comm_rank"() : () -> (!mpi.retval, i32)
    %errclass1 = "mpi.error_class"(%comm_rank_retval) : (!mpi.retval) -> !mpi.retval
    
    // Second set of operations from second IR fragment
    %buffer = memref.alloc() : memref<1024xi32>
    %tag = arith.constant 0 : i32
    %rank_const = arith.constant 0 : i32
    %recv_retval = "mpi.recv"(%buffer, %tag, %rank_const) : (memref<1024xi32>, i32, i32) -> !mpi.retval
    %errclass2 = "mpi.error_class"(%recv_retval) : (!mpi.retval) -> !mpi.retval
    
    // Finalize MPI
    %final_retval = "mpi.finalize"() : () -> !mpi.retval
    
    // Return the last error class result
    return %errclass2 : !mpi.retval
  }
}