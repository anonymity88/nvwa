module {
  mesh.mesh @mesh0(shape = 10x20x30)
  mesh.mesh @mesh1(shape = 2x2)

  func.func @main() -> (index, tensor<2x2xi8>, tensor<1x2xi8>) {
    // Get process linear index from mesh0
    %idx = mesh.process_linear_index on @mesh0 : index
    
    // Create constant input and perform broadcast on mesh1
    %input = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>
    %broadcast_result = mesh.broadcast %input on @mesh1 
                      mesh_axes = [0] 
                      root = [0] : (tensor<2x2xi8>) -> tensor<2x2xi8>
    
    // Use broadcast result as input to scatter operation
    %scatter_result = mesh.scatter %broadcast_result on @mesh1 
                     mesh_axes = [0] 
                     scatter_axis = 0 
                     root = [1] : (tensor<2x2xi8>) -> tensor<1x2xi8>
    
    return %idx, %broadcast_result, %scatter_result : index, tensor<2x2xi8>, tensor<1x2xi8>
  }
}