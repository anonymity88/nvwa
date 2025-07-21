module {
  mesh.mesh @mesh0(shape = 2x4)
  mesh.mesh @mesh1(shape = 2x2)

  func.func @main() -> (tensor<2x4xi8>, tensor<2x4xi8>, tensor<2x2xi8>) {
    // First operation: shift on mesh0
    %shift_input = arith.constant dense<[[1, 2, 3, 4], [5, 6, 7, 8]]> : tensor<2x4xi8>
    %shift_result = mesh.shift %shift_input on @mesh0 
                    mesh_axes = [1] 
                    shift_axis = 1 
                    offset = 2 
                    rotate : tensor<2x4xi8> -> tensor<2x4xi8>

    // Second operation: all_gather on mesh1
    %gather_input = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>
    %gather_result = mesh.all_gather %gather_input on @mesh1 
                    mesh_axes = [1] 
                    gather_axis = 1 
                    : tensor<2x2xi8> -> tensor<2x4xi8>

    // Third operation: all_slice on mesh1 using the gather result
    %slice_result = mesh.all_slice %gather_result on @mesh1 
                  mesh_axes = [1] 
                  slice_axis = 1 : tensor<2x4xi8> -> tensor<2x2xi8>

    return %shift_result, %gather_result, %slice_result : tensor<2x4xi8>, tensor<2x4xi8>, tensor<2x2xi8>
  }
}