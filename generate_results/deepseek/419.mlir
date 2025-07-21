module {
  func.func @main() -> (f64, i64, i32) {
    // Main function computations
    %0 = arith.constant 1.0 : f32
    %extended = arith.extf %0 : f32 to f64
    
    %b_div = arith.constant 7 : i64
    %c_div = arith.constant -2 : i64
    %ceil_div = arith.ceildivsi %b_div, %c_div : i64
    
    %b_add = arith.constant 10 : i32
    %c_add = arith.constant 20 : i32
    %a_add = arith.addi %b_add, %c_add : i32
    
    %d_add = arith.constant 30 : i32
    %e_add = arith.constant 40 : i32
    %f_add = arith.addi %d_add, %e_add overflow<nsw, nuw> : i32
    
    %g_vec = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %h_vec = arith.constant dense<[5, 6, 7, 8]> : vector<4xi32>
    %i_vec = arith.addi %g_vec, %h_vec : vector<4xi32>
    
    %j_tensor = arith.constant dense<[1, 2, 3, 4]> : tensor<4xi8>
    %k_tensor = arith.constant dense<[5, 6, 7, 8]> : tensor<4xi8>
    %l_tensor = arith.addi %j_tensor, %k_tensor : tensor<4xi8>
    
    %sum_all = arith.addi %a_add, %f_add : i32
    %sum_all_i64 = arith.extsi %sum_all : i32 to i64
    %final_div = arith.ceildivsi %sum_all_i64, %ceil_div : i64

    // Call to reduction function with some arbitrary indices
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c2 = arith.constant 2 : index
    %c3 = arith.constant 3 : index
    %c4 = arith.constant 4 : index
    call @reduction3(%c0, %c1, %c2, %c3, %c4) : (index, index, index, index, index) -> ()
    
    return %extended, %final_div, %sum_all : f64, i64, i32
  }

  func.func @reduction3(%arg0 : index, %arg1 : index, %arg2 : index,
                   %arg3 : index, %arg4 : index) {
    %step = arith.constant 1 : index
    %zero = arith.constant 0.0 : f32
    scf.parallel (%i0, %i1) = (%arg0, %arg1) to (%arg2, %arg3)
                              step (%arg4, %step) init (%zero) -> (f32) {
      %one = arith.constant 1.0 : f32
      scf.reduce(%one : f32) {
      ^bb0(%lhs : f32, %rhs: f32):
        %cmp = arith.cmpf oge, %lhs, %rhs : f32
        %res = arith.select %cmp, %lhs, %rhs : f32
        scf.reduce.return %res : f32
      }
    }
    return
  }
}