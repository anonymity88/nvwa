module {
  func.func @main() -> !spirv.ptr<f32, Function> {
    %0 = spirv.Constant 42.0 : f32
    %1 = spirv.Variable init(%0) : !spirv.ptr<f32, Function>
    return %1 : !spirv.ptr<f32, Function>
  }
}