module {
  func.func @main() -> (!mpi.retval) {
    // Declare a memref to hold incoming data
    %buffer = memref.alloc() : memref<1024xi32>

    // Constants for tag and rank
    %tag = arith.constant 0 : i32
    %rank = arith.constant 0 : i32

    // Perform a blocking receive operation using mpi.recv
    %retval = "mpi.recv"(%buffer, %tag, %rank) : (memref<1024xi32>, i32, i32) -> !mpi.retval

    // Additional operations using the received data would go here

    return %retval : !mpi.retval
  }
}