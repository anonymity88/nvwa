module {
  func.func @main() {
    %0 = llvm.mlir.constant(3.14159 : f32) : f32
    %1 = llvm.fpext %0 : f32 to f64
    llvm.return
  }
}