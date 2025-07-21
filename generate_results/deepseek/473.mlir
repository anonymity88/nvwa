module {
  func.func @main(%arg0: memref<i32>, %arg1: memref<i32>, %lb : index, %ub : index, %step : index) {
    // OMP target with depend clauses
    omp.target depend(taskdependin -> %arg0 : memref<i32>, taskdependin -> %arg1 : memref<i32>, taskdependinout -> %arg0 : memref<i32>) {
      omp.terminator
    } {operandSegmentSizes = array<i32: 0,0,0,3,0,0,0,0>}
    
    // OMP worksharing loop with cancel
    omp.wsloop {
      omp.loop_nest (%iv) : index = (%lb) to (%ub) step (%step) {
        omp.cancel cancellation_construct_type(loop)
        omp.yield
      }
      omp.terminator
    }
    return
  }
}