module attributes {dlti.dl_spec = #dlti.dl_spec<#dlti.dl_entry<"dlti.endianness", "big">>} {
  llvm.mlir.global private @const16(dense<[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]> : tensor<16 x i32>) : !llvm.array<16 x i32>

  llvm.func @smaller_store_forwarding_type_mix(%arg : vector<1xi8>) {
    %0 = llvm.mlir.constant(1 : i32) : i32
    %1 = llvm.alloca %0 x f32 : (i32) -> !llvm.ptr
    llvm.store %arg, %1 : vector<1xi8>, !llvm.ptr
    llvm.return
  }

  llvm.func @entry() -> i32 {
    %c0_i32 = llvm.mlir.constant(0 : i32) : i32
    %c0_i64 = llvm.mlir.constant(0 : index) : i64
    %c0_i8 = llvm.mlir.constant(0 : i8) : i8
    
    // Create vector for store forwarding test
    %vec = vector.splat %c0_i8 : vector<1xi8>
    
    // Call store forwarding function
    llvm.call @smaller_store_forwarding_type_mix(%vec) : (vector<1xi8>) -> ()
    
    // Main entry function logic
    %1 = llvm.mlir.addressof @const16 : !llvm.ptr
    %ptr = llvm.getelementptr %1[%c0_i64, %c0_i64] : (!llvm.ptr, i64, i64) -> !llvm.ptr, !llvm.array<16 x i32>
    %v = llvm.inline_asm asm_dialect = intel operand_attrs = [{ elementtype = vector<16xi32> }] "vmovdqu32 $0, $1", "=x,*m" %ptr : (!llvm.ptr) -> vector<16xi32>
    
    %v0 = vector.extract %v[0] : i32 from vector<16xi32>
    vector.print %v0 : i32
    %v9 = vector.extract %v[9] : i32 from vector<16xi32>
    vector.print %v9 : i32
    
    llvm.return %c0_i32 : i32
  }
}