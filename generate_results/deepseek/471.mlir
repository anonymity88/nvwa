module attributes {omp.is_target_device = false, omp.target_triples = ["amdgcn-amd-amdhsa"]} {
  llvm.func @_QQmain() attributes {fir.bindc_name = "main"} {
    %0 = llvm.mlir.addressof @_QFEi : !llvm.ptr
    %1 = llvm.mlir.addressof @_QFEsp : !llvm.ptr
    %2 = omp.map.info var_ptr(%1 : !llvm.ptr, i32) map_clauses(tofrom) capture(ByRef) -> !llvm.ptr {name = "sp"}
    %3 = omp.map.info var_ptr(%0 : !llvm.ptr, i32) map_clauses(to) capture(ByCopy) -> !llvm.ptr {name = "i"}
    omp.target map_entries(%2 -> %arg0, %3 -> %arg1 : !llvm.ptr, !llvm.ptr) {
      %4 = llvm.load %arg1 : !llvm.ptr -> i32
      llvm.store %4, %arg0 : i32, !llvm.ptr
      omp.terminator
    }
    llvm.return
  }

  llvm.mlir.global internal @_QFEi() {addr_space = 0 : i32} : i32 {
    %0 = llvm.mlir.constant(1 : i32) : i32
    llvm.return %0 : i32
  }

  llvm.mlir.global internal @_QFEsp() {addr_space = 0 : i32} : i32 {
    %0 = llvm.mlir.constant(0 : i32) : i32
    llvm.return %0 : i32
  }

  llvm.func @omp_target_region_() {
    %0 = llvm.mlir.constant(20 : i32) : i32
    %1 = llvm.mlir.constant(10 : i32) : i32
    %2 = llvm.mlir.constant(1 : i64) : i64
    %3 = llvm.alloca %2 x i32 {bindc_name = "a", in_type = i32, operandSegmentSizes = array<i32: 0, 0>, uniq_name = "_QFomp_target_regionEa"} : (i64) -> !llvm.ptr
    %4 = llvm.mlir.constant(1 : i64) : i64
    %5 = llvm.alloca %4 x i32 {bindc_name = "b", in_type = i32, operandSegmentSizes = array<i32: 0, 0>, uniq_name = "_QFomp_target_regionEb"} : (i64) -> !llvm.ptr
    %6 = llvm.mlir.constant(1 : i64) : i64
    %7 = llvm.alloca %6 x i32 {bindc_name = "c", in_type = i32, operandSegmentSizes = array<i32: 0, 0>, uniq_name = "_QFomp_target_regionEc"} : (i64) -> !llvm.ptr
    llvm.store %1, %3 : i32, !llvm.ptr
    llvm.store %0, %5 : i32, !llvm.ptr
    omp.task {
      %map1 = omp.map.info var_ptr(%3 : !llvm.ptr, i32) map_clauses(tofrom) capture(ByRef) -> !llvm.ptr {name = ""}
      %map2 = omp.map.info var_ptr(%5 : !llvm.ptr, i32) map_clauses(tofrom) capture(ByRef) -> !llvm.ptr {name = ""}
      %map3 = omp.map.info var_ptr(%7 : !llvm.ptr, i32) map_clauses(tofrom) capture(ByRef) -> !llvm.ptr {name = ""}
      omp.target map_entries(%map1 -> %arg0, %map2 -> %arg1, %map3 -> %arg2 : !llvm.ptr, !llvm.ptr, !llvm.ptr) {
        %8 = llvm.load %arg0 : !llvm.ptr -> i32
        %9 = llvm.load %arg1 : !llvm.ptr -> i32
        %10 = llvm.add %8, %9 : i32
        llvm.store %10, %arg2 : i32, !llvm.ptr
        omp.terminator
      }
      omp.terminator
    }
    llvm.return
  }

  llvm.func @omp_target_no_map() {
    omp.target {
      omp.terminator
    }
    llvm.return
  }

  // Add a main function that calls the other functions to establish data flow
  func.func @main() {
    // Call the OpenMP functions to establish dependencies
    llvm.call @_QQmain() : () -> ()
    llvm.call @omp_target_region_() : () -> ()
    llvm.call @omp_target_no_map() : () -> ()
    return
  }
}