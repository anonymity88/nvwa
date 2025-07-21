module {
  func.func @main() {
    // Initialize a vector with elements 1.0 to 16.0 of type f32
    %vec = arith.constant dense<[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 
                                 7.0, 8.0, 9.0, 10.0, 11.0, 
                                 12.0, 13.0, 14.0, 15.0, 16.0]> : vector<16xf32>
    
    // Define the index to extract the element from the vector
    %index = arith.constant 5 : index

    // Extract the element from the vector at the specified index
    %result = vector.extractelement %vec[%index : index] : vector<16xf32>

    return
  }
}