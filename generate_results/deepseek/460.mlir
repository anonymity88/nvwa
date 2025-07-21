module {
  func.func @main(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: !llvm.ptr, %arg4: !llvm.ptr, %arg5: !llvm.ptr) -> () attributes {omp.requires = #omp<clause_requires unified_address|dynamic_allocators>} {
    // Target enter data with map operations
    %mapv1 = omp.map.info var_ptr(%arg0 : !llvm.ptr, i32) map_clauses(to) capture(ByRef) -> !llvm.ptr {name = ""}
    %mapv2 = omp.map.info var_ptr(%arg1 : !llvm.ptr, f32) map_clauses(to) capture(ByRef) -> !llvm.ptr {name = ""}
    %mapv3 = omp.map.info var_ptr(%arg2 : !llvm.ptr, !llvm.struct<(i32, f32)>) map_clauses(to) capture(ByRef) members(%mapv1, %mapv2 : [0], [1] : !llvm.ptr, !llvm.ptr) -> !llvm.ptr {name = "", partial_map = true}
    omp.target_enter_data map_entries(%mapv1, %mapv2, %mapv3 : !llvm.ptr, !llvm.ptr, !llvm.ptr){}

    // Target exit data with map operations
    %mapv4 = omp.map.info var_ptr(%arg3 : !llvm.ptr, i32) map_clauses(from) capture(ByRef) -> !llvm.ptr {name = ""}
    %mapv5 = omp.map.info var_ptr(%arg4 : !llvm.ptr, f32) map_clauses(from) capture(ByRef) -> !llvm.ptr {name = ""}
    %mapv6 = omp.map.info var_ptr(%arg5 : !llvm.ptr, !llvm.struct<(i32, struct<(i32, f32)>)>) map_clauses(from) capture(ByRef) members(%mapv4, %mapv5 : [1,0], [1,1] : !llvm.ptr, !llvm.ptr) -> !llvm.ptr {name = "", partial_map = true}
    omp.target_exit_data map_entries(%mapv4, %mapv5, %mapv6 : !llvm.ptr, !llvm.ptr, !llvm.ptr){}

    return
  }
}