module {
  func.func @main(%x: i1, %y: i1) -> i1 {
    %result = spirv.LogicalNotEqual %x, %y : i1
    return %result : i1
  }
  
  func.func @vector_example(%v1: vector<4xi1>, %v2: vector<4xi1>) -> vector<4xi1> {
    %result_vec = spirv.LogicalNotEqual %v1, %v2 : vector<4xi1>
    return %result_vec : vector<4xi1>
  }
}