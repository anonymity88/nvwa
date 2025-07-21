module {
  func.func @main(%arg0: i32, %arg1: i32) -> !llvm.array<256 x i8> {
    %0 = "amx.tilezero"(%arg0, %arg1) : (i32, i32) -> !llvm.array<256 x i8>
    return %0 : !llvm.array<256 x i8>
  }
}