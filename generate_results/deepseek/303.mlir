module {
  func.func @process_data(%arg0: i32, %arg1: f32) -> (i32, f32) {
    %0 = arith.addi %arg0, %arg0 : i32
    %1 = arith.mulf %arg1, %arg1 : f32
    return %0, %1 : i32, f32
  }

  func.func @add_tensors(%arg0: tensor<16xf32>, %arg1: tensor<16xf32>) -> tensor<16xf32> {
    %result = arith.addf %arg0, %arg1 : tensor<16xf32>
    return %result : tensor<16xf32>
  }

  func.func @my_add(%arg0: f32, %arg1: f32) -> f32 {
    %0 = arith.addf %arg0, %arg1 : f32
    return %0 : f32
  }

  func.func @same_rank_success(%t1xi : tensor<1xi32>, %t2xf : tensor<2xf32>, %m3xi : memref<3xi32>, %t1x2xf : tensor<1x2xf32>, %t1x2xi : tensor<1x2xi32>) {
    "test.operands_have_same_rank"(%t1xi, %t2xf) : (tensor<1xi32>, tensor<2xf32>) -> ()
    "test.operands_have_same_rank"(%t1xi, %m3xi) : (tensor<1xi32>, memref<3xi32>) -> ()
    "test.operand0_and_result_have_same_rank"(%t1xi, %t1x2xf) : (tensor<1xi32>, tensor<1x2xf32>) -> (tensor<3xf32>)
    "test.operand0_and_result_have_same_rank"(%t1x2xi, %t1x2xf) : (tensor<1x2xi32>, tensor<1x2xf32>) -> (tensor<3x3xf64>)
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

    // Prepare inputs for same_rank_success
    %t1xi = arith.constant dense<1> : tensor<1xi32>
    %t2xf = arith.constant dense<1.0> : tensor<2xf32>
    %m3xi = memref.alloc() : memref<3xi32>
    %t1x2xf = arith.constant dense<1.0> : tensor<1x2xf32>
    %t1x2xi = arith.constant dense<1> : tensor<1x2xi32>
    
    call @same_rank_success(%t1xi, %t2xf, %m3xi, %t1x2xf, %t1x2xi) : 
      (tensor<1xi32>, tensor<2xf32>, memref<3xi32>, tensor<1x2xf32>, tensor<1x2xi32>) -> ()

    return
  }
}