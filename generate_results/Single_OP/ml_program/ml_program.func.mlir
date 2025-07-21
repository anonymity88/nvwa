module {
  // Define a private function that takes an integer and returns an integer
  ml_program.func private @some_extern(%arg0: i32) -> i32 {
    ml_program.return %arg0 : i32
  }

  // Define a public function that performs a basic computation
  ml_program.func @compute_square(%arg0: i32) -> i32 {
    // Multiply the input argument with itself to compute the square
    %0 = arith.muli %arg0, %arg0 : i32
    ml_program.return %0 : i32
  }
}