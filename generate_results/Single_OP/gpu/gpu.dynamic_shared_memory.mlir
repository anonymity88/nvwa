module {
  func.func @main() {
    %dyn_shared_mem = gpu.dynamic_shared_memory : memref<?xi8, #gpu.address_space<workgroup>>

    // Assuming we need to view the dynamic shared memory for a specific layout
    %c8192 = arith.constant 8192 : index
    %view1 = memref.view %dyn_shared_mem[%c8192][] : memref<?xi8, #gpu.address_space<workgroup>>
                               to memref<32x64xf32, #gpu.address_space<workgroup>>

    %c16384 = arith.constant 16384 : index
    %view2 = memref.view %dyn_shared_mem[%c16384][] : memref<?xi8, #gpu.address_space<workgroup>>
                               to memref<32x64xf32, #gpu.address_space<workgroup>>

    return
  }
}