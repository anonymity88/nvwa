module {
  func.func @main() {
    // Define the input vector representing a 4x4 matrix stored in a flattened manner
    %matrix = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 
                                    5.0, 6.0, 7.0, 8.0, 
                                    9.0, 10.0, 11.0, 12.0, 
                                    13.0, 14.0, 15.0, 16.0]> : vector<16xf32>
    
    // Transpose the flattened matrix representation
    %transposed = vector.flat_transpose %matrix {rows = 4 : i32, columns = 4 : i32} : vector<16xf32> -> vector<16xf32>

    return
  }
}