module {
  func.func @main(%component: f32, %vector: vector<8xf32>, %index: i32) -> vector<8xf32> {
    %result = spirv.VectorInsertDynamic %component, %vector[%index] : vector<8xf32>, i32
    return %result : vector<8xf32>
  }

  func.func @integer_example(%component: i32, %vector: vector<4xi32>, %index: i32) -> vector<4xi32> {
    %result = spirv.VectorInsertDynamic %component, %vector[%index] : vector<4xi32>, i32
    return %result : vector<4xi32>
  }
}