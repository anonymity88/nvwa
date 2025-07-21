module {
  spirv.GlobalVariable @var0 : !spirv.ptr<f32, Input> 
  spirv.GlobalVariable @var1 initializer(@var0) : !spirv.ptr<f32, Output>
  spirv.GlobalVariable @var2 bind(1, 2) : !spirv.ptr<f32, Uniform>
  spirv.GlobalVariable @var3 built_in("GlobalInvocationId") : !spirv.ptr<vector<3xi32>, Input>

  func.func @main() {
    return
  }
}