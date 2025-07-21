module {
  func.func @reduce_sum(%buffer: memref<1024xf32>, %lb: index,
                       %ub: index, %step: index) -> f32 {
    %initial_sum = arith.constant 0.0 : f32
    %final_sum = scf.for %iv = %lb to %ub step %step
        iter_args(%sum_iter = %initial_sum) -> (f32) {
      %element = memref.load %buffer[%iv] : memref<1024xf32>
      %updated_sum = arith.addf %sum_iter, %element : f32
      scf.yield %updated_sum : f32
    }
    return %final_sum : f32
  }

  func.func @select_value(%condition: i1, %trueValue: f32, %falseValue: f32) -> f32 {
    %result = scf.if %condition -> (f32) {
      scf.yield %trueValue : f32
    } else {
      scf.yield %falseValue : f32
    }
    return %result : f32
  }

  func.func @process_data_with_reduction(%buffer: memref<1024xf32>, %lb: index, %ub: index, %step: index, %threshold: f32) -> (f32, f32) {
    %sum = call @reduce_sum(%buffer, %lb, %ub, %step) : (memref<1024xf32>, index, index, index) -> f32
    
    %zero = arith.constant 0.0 : f32
    %cond = arith.cmpf "ogt", %sum, %zero : f32
    
    %one = arith.constant 1.0 : f32
    %neg_one = arith.constant -1.0 : f32
    %selected = call @select_value(%cond, %one, %neg_one) : (i1, f32, f32) -> f32
    
    return %sum, %selected : f32, f32
  }

  func.func private @private2(%0 : i32) -> i32 {
    %cond = arith.index_cast %0 {tag = "in_private2"} : i32 to index
    %1 = scf.index_switch %cond -> i32
    case 1 {
      %ten = arith.constant 10 : i32
      scf.yield %ten : i32
    }
    case 2 {
      %twenty = arith.constant 20 : i32
      scf.yield %twenty : i32
    }
    default {
      %thirty = arith.constant 30 : i32
      scf.yield %thirty : i32
    }
    func.return %1 : i32
  }

  func.func @parallel_region_no_read() {
    %alloc0 = bufferization.alloc_tensor() : tensor<320xf32>
    %alloc1 = bufferization.alloc_tensor() : tensor<1xf32>
    %c320 = arith.constant 320 : index
    scf.forall (%arg0) in (%c320) {
      %val = "test.foo"() : () -> (f32)
      %fill = linalg.fill ins(%val : f32) outs(%alloc1 : tensor<1xf32>) -> tensor<1xf32>
      scf.forall.in_parallel {
      }
    }
    return
  }

  func.func @main(%input_buffer: memref<1024xf32>, %lb: index, %ub: index, %step: index, 
                  %threshold: f32, %switch_input: i32) -> (f32, f32, i32) {
    %sum_result, %selected_value = call @process_data_with_reduction(%input_buffer, %lb, %ub, %step, %threshold) : 
                                  (memref<1024xf32>, index, index, index, f32) -> (f32, f32)
    
    %switch_result = call @private2(%switch_input) : (i32) -> i32
    
    call @parallel_region_no_read() : () -> ()
    
    return %sum_result, %selected_value, %switch_result : f32, f32, i32
  }
}