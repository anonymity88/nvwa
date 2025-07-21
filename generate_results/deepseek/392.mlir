module {
  ml_program.global public mutable @foobar : tensor<4xi32>
  ml_program.global private mutable @global(dense<0> : tensor<i64>) : tensor<i64>

  ml_program.subgraph private @simple_subgraph(%arg0: i32) -> i32 {
    ml_program.output %arg0 : i32
  }

  ml_program.subgraph @add_subgraph(%a: i32, %b: i32) -> i32 {
    %sum = arith.addi %a, %b : i32
    ml_program.output %sum : i32
  }

  func.func @main() -> !ml_program.token {
    %0 = arith.constant dense<[1, 2, 3, 4]> : tensor<4xi32>
    %in_token = "ml_program.token"() : () -> !ml_program.token
    %token = ml_program.global_store_graph @foobar = %0 
      ordering (%in_token -> !ml_program.token) : tensor<4xi32>
    
    // Call global_load_store function
    %global_result = func.call @global_load_store() : () -> i64
    
    return %token : !ml_program.token
  }

  func.func @global_load_store() -> i64 {
    %c127 = arith.constant 127 : i64
    %0 = ml_program.global_load @global : tensor<i64>
    %extracted = tensor.extract %0[] : tensor<i64>
    %1 = arith.muli %extracted, %c127 : i64
    %inserted = tensor.insert %1 into %0[] : tensor<i64>
    ml_program.global_store @global = %inserted : tensor<i64>
    return %1 : i64
  }
}