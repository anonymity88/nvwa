module {
  func.func @main() -> () {
    // Call the comparison functions with some constants
    %a = spirv.Constant 3.14 : f32
    %b = spirv.Constant 3.14 : f32
    %cmp_result = call @compare_scalars(%a, %b) : (f32, f32) -> i1

    %v1 = spirv.Constant dense<[1.0, 2.0, 3.0, 4.0]> : vector<4xf32>
    %v2 = spirv.Constant dense<[1.0, 2.0, 3.0, 5.0]> : vector<4xf32>
    %vec_cmp_result = call @compare_vectors(%v1, %v2) : (vector<4xf32>, vector<4xf32>) -> vector<4xi1>

    // Call the min functions with some constants
    %x = spirv.Constant 5 : i32
    %y = spirv.Constant 3 : i32
    %min_result = call @min_scalars(%x, %y) : (i32, i32) -> i32

    %v3 = spirv.Constant dense<[5, 2, 7, 1]> : vector<4xi32>
    %v4 = spirv.Constant dense<[3, 4, 5, 2]> : vector<4xi32>
    %vec_min_result = call @min_vectors(%v3, %v4) : (vector<4xi32>, vector<4xi32>) -> vector<4xi32>

    // Call the empty functions
    call @empty_function() : () -> ()
    call @another_empty_function() : () -> ()

    spirv.Return
  }

  func.func @compare_scalars(%a: f32, %b: f32) -> i1 {
    %result = spirv.FOrdEqual %a, %b : f32
    return %result : i1
  }

  func.func @compare_vectors(%v1: vector<4xf32>, %v2: vector<4xf32>) -> vector<4xi1> {
    %result_vec = spirv.FOrdEqual %v1, %v2 : vector<4xf32>
    return %result_vec : vector<4xi1>
  }

  func.func @min_scalars(%x: i32, %y: i32) -> i32 {
    %result = spirv.CL.u_min %x, %y : i32
    return %result : i32
  }

  func.func @min_vectors(%v1: vector<4xi32>, %v2: vector<4xi32>) -> vector<4xi32> {
    %result_vec = spirv.CL.u_min %v1, %v2 : vector<4xi32>
    return %result_vec : vector<4xi32>
  }

  func.func @empty_function() -> () {
    spirv.Return
  }

  func.func @another_empty_function() -> () {
    spirv.Return
  }
}