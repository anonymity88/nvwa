module {
  func.func @main() {
    // Assume we have a previously defined SpGEMM descriptor handle.
    %desc = some_op_returning_spgemm_descr() : !gpu.spgemm_descr  // Placeholder for obtaining the SpGEMM descriptor

    // Assuming a previous async dependency operation.
    %dep = gpu.wait() { async = true } : () -> !gpu.async.token

    // Perform the gpu.spgemm_destroy_descr operation to destroy the descriptor asynchronously.
    %token = gpu.spgemm_destroy_descr async [%dep] %desc : (!gpu.async.token, !gpu.spgemm_descr)

    return
  }
}