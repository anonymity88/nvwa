module {
  func.func @main() -> (index) {
    // Get the number of threads in the threadpool from the async runtime
    %result = "async.runtime.num_worker_threads"() : () -> index
    return %result : index
  }
}