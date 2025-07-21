module {
  func.func @main() {
    %0 = spirv.Variable : !spirv.ptr<f32, Function>
    %1 = spirv.Variable : !spirv.ptr<f32, Function>
    spirv.CopyMemory "Function" %0, "Function" %1 : f32
    return
  }

  func.func @copy_example(%src: !spirv.ptr<f32, Function>, %dst: !spirv.ptr<f32, Function>) {
    spirv.CopyMemory "Function" %src, "Function" %dst : f32
    return
  }
}