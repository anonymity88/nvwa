module {
  func.func @main() -> !mpi.retval {
    // Initialize MPI
    "mpi.init"() : () -> ()
    
    // Get current process rank
    %comm_rank_retval, %rank = "mpi.comm_rank"() : () -> (!mpi.retval, i32)
    
    // Check for errors in comm_rank operation
    %errclass = "mpi.error_class"(%comm_rank_retval) : (!mpi.retval) -> !mpi.retval
    
    return %errclass : !mpi.retval
  }
}