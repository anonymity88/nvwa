module {
  func.func @main() -> (f64, i64, i32) {
    // Floating-point extension operation
    %0 = arith.constant 1.0 : f32
    %extended = arith.extf %0 : f32 to f64
    
    // Integer ceiling division operation
    %b_div = arith.constant 7 : i64
    %c_div = arith.constant -2 : i64
    %ceil_div = arith.ceildivsi %b_div, %c_div : i64
    
    // Integer addition operations
    %b_add = arith.constant 10 : i32
    %c_add = arith.constant 20 : i32
    %a_add = arith.addi %b_add, %c_add : i32
    
    // Integer addition with overflow flags
    %d_add = arith.constant 30 : i32
    %e_add = arith.constant 40 : i32
    %f_add = arith.addi %d_add, %e_add overflow<nsw, nuw> : i32
    
    // Vector addition
    %g_vec = arith.constant dense<[1, 2, 3, 4]> : vector<4xi32>
    %h_vec = arith.constant dense<[5, 6, 7, 8]> : vector<4xi32>
    %i_vec = arith.addi %g_vec, %h_vec : vector<4xi32>
    
    // Tensor addition
    %j_tensor = arith.constant dense<[1, 2, 3, 4]> : tensor<4xi8>
    %k_tensor = arith.constant dense<[5, 6, 7, 8]> : tensor<4xi8>
    %l_tensor = arith.addi %j_tensor, %k_tensor : tensor<4xi8>
    
    // Use the results of some operations in others
    %sum_all = arith.addi %a_add, %f_add : i32
    %sum_all_i64 = arith.extsi %sum_all : i32 to i64
    %final_div = arith.ceildivsi %sum_all_i64, %ceil_div : i64
    
    // Return all three main results
    return %extended, %final_div, %sum_all : f64, i64, i32
  }
}