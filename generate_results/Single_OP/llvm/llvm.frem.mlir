module {
  func.func @main() {
    %0 = llvm.mlir.constant(7.25 : f64) : f64
    %1 = llvm.mlir.constant(2.0 : f64) : f64
    %2 = llvm.frem %0, %1 : f64
    llvm.return
  }
}