module {
  mesh.mesh @mesh0(shape = 2x2)
  mesh.mesh @mesh1(shape = 2x4)

  func.func @main(%input1 : tensor<2x2xi8>, %input2 : tensor<2x4xi8>) -> (tensor<1x2xi8>, tensor<2x2xi8>, tensor<2x4xi8>) {
    // Scatter operation on mesh0
    %scatter_result = mesh.scatter %input1 on @mesh0 
                     mesh_axes = [0] 
                     scatter_axis = 0 
                     root = [1] : (tensor<2x2xi8>) -> tensor<1x2xi8>
    
    // All_slice operation on mesh0
    %slice_result = mesh.all_slice %input2 on @mesh0 
                  mesh_axes = [1] 
                  slice_axis = 1 : tensor<2x4xi8> -> tensor<2x2xi8>
    
    // Shift operation on mesh1
    %shift_input = arith.constant dense<[[1, 2, 3, 4], [5, 6, 7, 8]]> : tensor<2x4xi8>
    %shift_result = mesh.shift %shift_input on @mesh1 
                  mesh_axes = [1] 
                  shift_axis = 1 
                  offset = 2 
                  rotate : tensor<2x4xi8> -> tensor<2x4xi8>
    
    return %scatter_result, %slice_result, %shift_result : tensor<1x2xi8>, tensor<2x2xi8>, tensor<2x4xi8>
  }
}