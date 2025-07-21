module {
  func.func @main() {
    %tIdX = gpu.thread_id x
    %tIdY = gpu.thread_id y
    %tIdZ = gpu.thread_id z

    return
  }
}