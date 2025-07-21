module {
  mesh.mesh @mesh0(shape = 2x2)
  mesh.mesh @mesh1(shape = 3x4x5)

  func.func @main() -> (tensor<2x2xi8>, index, index, index, tensor<1x2xi8>) {
    // Broadcast operation
    %input = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>
    %broadcast_result = mesh.broadcast %input on @mesh0 
                      mesh_axes = [0] 
                      root = [0] : (tensor<2x2xi8>) -> tensor<2x2xi8>

    // Mesh shape operation
    %d0, %d1, %d2 = mesh.mesh_shape @mesh1 : index, index, index

    // Scatter operation using the broadcast result as input
    %scatter_result = mesh.scatter %broadcast_result on @mesh0 
                     mesh_axes = [0] 
                     scatter_axis = 0 
                     root = [1] : (tensor<2x2xi8>) -> tensor<1x2xi8>

    return %broadcast_result, %d0, %d1, %d2, %scatter_result : tensor<2x2xi8>, index, index, index, tensor<1x2xi8>
  }
}