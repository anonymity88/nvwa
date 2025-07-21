module {
  func.func @add_tensors(%arg0: tensor<16xf32>, %arg1: tensor<16xf32>) -> tensor<16xf32> {
    %result = arith.addf %arg0, %arg1 : tensor<16xf32>
    return %result : tensor<16xf32>
  }

  func.func @my_add(%arg0: f32, %arg1: f32) -> f32 {
    %0 = arith.addf %arg0, %arg1 : f32
    return %0 : f32
  }

  func.func @process_data(%arg0: i32, %arg1: f32) -> (i32, f32) {
    %0 = arith.addi %arg0, %arg0 : i32
    %1 = arith.mulf %arg1, %arg1 : f32
    return %0, %1 : i32, f32
  }

  func.func @depthwise_conv1d_ncw_cw(%input: memref<3x?x4xf32>, %filter: memref<?x1xf32>, %output: memref<3x?x4xf32>) {
    linalg.depthwise_conv_1d_ncw_cw
      {dilations = dense<2> : tensor<1xi64>, strides = dense<1> : tensor<1xi64>}
      ins(%input, %filter : memref<3x?x4xf32>, memref<?x1xf32>)
      outs(%output : memref<3x?x4xf32>)
    return
  }

  func.func @main() {
    %const_i32 = arith.constant 5 : i32
    %const_f32 = arith.constant 2.5 : f32
    %result0, %result1 = call @process_data(%const_i32, %const_f32) : (i32, f32) -> (i32, f32)

    %scalar_a = arith.constant 1.0 : f32
    %scalar_b = arith.constant 2.0 : f32
    %scalar_result = call @my_add(%scalar_a, %scalar_b) : (f32, f32) -> f32

    %tensor_a = arith.constant dense<1.0> : tensor<16xf32>
    %tensor_b = arith.constant dense<2.0> : tensor<16xf32>
    %tensor_result = call @add_tensors(%tensor_a, %tensor_b) : (tensor<16xf32>, tensor<16xf32>) -> tensor<16xf32>

    // Allocate dynamic memrefs for depthwise conv
    %c3 = arith.constant 3 : index
    %c4 = arith.constant 4 : index
    %c8 = arith.constant 8 : index
    
    %input = memref.alloc(%c8) : memref<3x?x4xf32>
    %filter = memref.alloc(%c8) : memref<?x1xf32>
    %output = memref.alloc(%c8) : memref<3x?x4xf32>
    
    call @depthwise_conv1d_ncw_cw(%input, %filter, %output) : (memref<3x?x4xf32>, memref<?x1xf32>, memref<3x?x4xf32>) -> ()
    
    return
  }
}