module {
  func.func @main() -> !mpi.retval {
    // Initialize MPI
    "mpi.init"() : () -> ()
    
    // Allocate buffer for receiving data
    %buffer = memref.alloc() : memref<1024xi32>
    
    // Define tag and rank for communication
    %tag = arith.constant 0 : i32
    %rank = arith.constant 0 : i32
    
    // Receive data through MPI
    %recv_retval = "mpi.recv"(%buffer, %tag, %rank) : (memref<1024xi32>, i32, i32) -> !mpi.retval
    
    // Check for errors in receive operation
    %errclass = "mpi.error_class"(%recv_retval) : (!mpi.retval) -> !mpi.retval
    
    // Finalize MPI
    "mpi.finalize"() : () -> ()
    
    // Return the error class from receive operation
    return %errclass : !mpi.retval
  }
}