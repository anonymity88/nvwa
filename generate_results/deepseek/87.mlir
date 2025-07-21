#gpu_address_space = #gpu.address_space<workgroup>

module {
  func.func @main() {
    // Set default device first
    %devIndex = arith.constant 0 : i32
    gpu.set_default_device %devIndex

    // Allocate dynamic shared memory
    %dyn_shared_mem = gpu.dynamic_shared_memory : memref<?xi8, #gpu_address_space>

    // Create views from dynamic shared memory
    %c8192 = arith.constant 8192 : index
    %view1 = memref.view %dyn_shared_mem[%c8192][] : memref<?xi8, #gpu_address_space> to memref<32x64xf32, #gpu_address_space>

    %c16384 = arith.constant 16384 : index
    %view2 = memref.view %dyn_shared_mem[%c16384][] : memref<?xi8, #gpu_address_space> to memref<32x64xf32, #gpu_address_space>

    // Async memory allocation
    %dep = "gpu.wait"() { async = true } : () -> !gpu.async.token
    %width = arith.constant 64 : index
    %memref, %token = gpu.alloc async [%dep] host_shared (%width) : memref<64x?xf32, 1>

    return
  }
}