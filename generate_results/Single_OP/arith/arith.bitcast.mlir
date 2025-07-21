module {
  func.func @main() {
    %0 = arith.constant 42 : i32
    %1 = arith.bitcast %0 : i32 to f32
    %2 = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %3 = arith.bitcast %2 : vector<4xi32> to vector<4xf32>
    return
  }
}