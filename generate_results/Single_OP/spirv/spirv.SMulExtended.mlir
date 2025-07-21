module {
  func.func @main(%a: i32, %b: i32) -> !spirv.struct<(i32, i32)> {
    %result = spirv.SMulExtended %a, %b : !spirv.struct<(i32, i32)>
    return %result : !spirv.struct<(i32, i32)>
  }

  func.func @vector_example(%v1: vector<2xi32>, %v2: vector<2xi32>) -> !spirv.struct<(vector<2xi32>, vector<2xi32>)> {
    %result_vec = spirv.SMulExtended %v1, %v2 : !spirv.struct<(vector<2xi32>, vector<2xi32>)>
    return %result_vec : !spirv.struct<(vector<2xi32>, vector<2xi32>)>
  }
}