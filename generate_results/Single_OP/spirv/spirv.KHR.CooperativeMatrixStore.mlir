module {
  func.func @main(%ptr: !spirv.ptr<i32, StorageBuffer>, %obj: !spirv.coopmatrix<16x8xi32, Workgroup, MatrixA>, %stride: i32) -> () {
    spirv.KHR.CooperativeMatrixStore %ptr, %obj, %stride, <RowMajor> : 
      !spirv.ptr<i32, StorageBuffer>, !spirv.coopmatrix<16x8xi32, Workgroup, MatrixA>, i32
    return
  }

  func.func @example_with_memory_operand(%ptr: !spirv.ptr<f32, StorageBuffer>, %obj: !spirv.coopmatrix<8x8xf32, Subgroup, MatrixAcc>, %stride: i64) -> () {
    spirv.KHR.CooperativeMatrixStore %ptr, %obj, %stride, <ColumnMajor>, <Volatile> : 
      !spirv.ptr<f32, StorageBuffer>, !spirv.coopmatrix<8x8xf32, Subgroup, MatrixAcc>, i64
    return
  }
}