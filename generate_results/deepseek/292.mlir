module {
  mesh.mesh @mesh0(shape = 2x4)
  mesh.mesh @mesh1(shape = 2x2)
  mesh.mesh @mesh2(shape = 4x?x2)

  func.func @main() -> (tensor<2x4xi8>, tensor<2x4xi8>, tensor<2x2xi8>) {
    %shift_input = arith.constant dense<[[1, 2, 3, 4], [5, 6, 7, 8]]> : tensor<2x4xi8>
    %shift_result = mesh.shift %shift_input on @mesh0 
                    mesh_axes = [1] 
                    shift_axis = 1 
                    offset = 2 
                    rotate : tensor<2x4xi8> -> tensor<2x4xi8>

    %gather_input = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>
    %gather_result = mesh.all_gather %gather_input on @mesh1 
                    mesh_axes = [1] 
                    gather_axis = 1 
                    : tensor<2x2xi8> -> tensor<2x4xi8>

    %slice_result = mesh.all_slice %gather_result on @mesh1 
                  mesh_axes = [1] 
                  slice_axis = 1 : tensor<2x4xi8> -> tensor<2x2xi8>

    return %shift_result, %gather_result, %slice_result : tensor<2x4xi8>, tensor<2x4xi8>, tensor<2x2xi8>
  }

  func.func private @mesh_to_inline() -> (index, index) {
    %0:2 = mesh.mesh_shape @mesh2 axes = [2, 1] : index, index
    return %0#0, %0#1 : index, index
  }
}