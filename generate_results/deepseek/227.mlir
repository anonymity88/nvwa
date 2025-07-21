module {
  func.func @main() {
    // Vector step operation
    %step_vector = vector.step : vector<4xindex>

    // Splat operation
    %s = arith.constant 10.1 : f32
    %t = vector.splat %s : vector<8x16xf32>

    // Matrix transpose operation
    %matrix = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 
                                    5.0, 6.0, 7.0, 8.0, 
                                    9.0, 10.0, 11.0, 12.0, 
                                    13.0, 14.0, 15.0, 16.0]> : vector<16xf32>
    %transposed = vector.flat_transpose %matrix {rows = 4 : i32, columns = 4 : i32} : vector<16xf32> -> vector<16xf32>

    return
  }
}