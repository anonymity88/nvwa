module {
  func.func @main() {
    amdgpu.sched_barrier allow = #amdgpu.sched_barrier_opt<valu>
    return
  }
}