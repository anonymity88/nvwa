module {
  func.func @main() {
    // Define constants for initial size, buffer, value to add, and repetitions
    %curSize = arith.constant 10 : index
    %val = arith.constant 3.14 : f64
    %n = arith.constant 5 : index

    // Allocate buffer with dynamic size
    %buffer = memref.alloc(%curSize) : memref<?xf64>

    // Perform push_back operation on sparse tensor buffer
    %newBuffer, %newSize = sparse_tensor.push_back %curSize, %buffer, %val, %n
      : index, memref<?xf64>, f64, index

    // another example with 'inbounds' attribute
    %inCurSize = arith.constant 20 : index
    %inVal = arith.constant 6.28 : f64

    // Allocate another buffer with dynamic size
    %inBuffer = memref.alloc(%inCurSize) : memref<?xf64>

    %newInBuffer, %newInSize = sparse_tensor.push_back inbounds %inCurSize, %inBuffer, %inVal
      : index, memref<?xf64>, f64

    // Return from main function
    return
  }
}