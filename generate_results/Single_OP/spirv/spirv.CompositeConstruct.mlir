module {
  func.func @main(%x: f32, %y: f32, %z: f32) -> vector<3xf32> {
    %result = spirv.CompositeConstruct %x, %y, %z : (f32, f32, f32) -> vector<3xf32>
    return %result : vector<3xf32>
  }

  func.func @nested_example(%a: vector<2xf32>, %b: f32) -> vector<3xf32> {
    %result_vec = spirv.CompositeConstruct %a, %b : (vector<2xf32>, f32) -> vector<3xf32>
    return %result_vec : vector<3xf32>
  }

  func.func @struct_example(%v: vector<3xf32>, %arr: !spirv.array<4xf32>, %s: !spirv.struct<(f32)>) -> !spirv.struct<(vector<3xf32>, !spirv.array<4xf32>, !spirv.struct<(f32)>)> {
    %result_struct = spirv.CompositeConstruct %v, %arr, %s : (vector<3xf32>, !spirv.array<4xf32>, !spirv.struct<(f32)>) -> !spirv.struct<(vector<3xf32>, !spirv.array<4xf32>, !spirv.struct<(f32)>)>
    return %result_struct : !spirv.struct<(vector<3xf32>, !spirv.array<4xf32>, !spirv.struct<(f32)>)>
  }
}