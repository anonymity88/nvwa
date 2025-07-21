module {
  func.func @main(%arg0: memref<?xf32, 5>, %arg1: memref<5x4xi32, 3>, 
                 %src_copy: memref<10xf32>, %dst_copy: memref<10xf32>,
                 %reshape_src: memref<4x1xf32>, %shape: memref<1xi32>) -> memref<4xf32> {
    %cast1 = memref.memory_space_cast %arg0 : memref<?xf32, 5> to memref<?xf32>
    %cast2 = memref.memory_space_cast %arg1 : memref<5x4xi32, 3> to memref<5x4xi32>
    
    memref.copy %src_copy, %dst_copy : memref<10xf32> to memref<10xf32>
    
    %reshaped = memref.reshape %reshape_src(%shape) : (memref<4x1xf32>, memref<1xi32>) -> memref<4xf32>
    
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1.0 : f32
    memref.store %c1, %cast1[%c0] : memref<?xf32>
    
    %c0_i32 = arith.constant 0 : i32
    %c0_0 = arith.constant 0 : index
    %c0_1 = arith.constant 0 : index
    memref.store %c0_i32, %cast2[%c0_0, %c0_1] : memref<5x4xi32>
    
    call @test_opaque_call_return() : () -> ()
    
    return %reshaped : memref<4xf32>
  }

  func.func private @void_return(%ptr: memref<i32>)

  func.func @test_opaque_call_return() {
    %ptr = memref.alloc() : memref<i32>
    %c0 = arith.constant 0 : i32
    memref.store %c0, %ptr[] {tag_name = "write0"} : memref<i32>
    func.call @void_return(%ptr) : (memref<i32>) -> ()
    %loaded = memref.load %ptr[] {tag = "after_opaque_call"} : memref<i32>
    return
  }
}