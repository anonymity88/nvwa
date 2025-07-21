module {
  mesh.mesh @mesh0(shape = 10x20x30)
  mesh.mesh @mesh1(shape = 2x2)
  mesh.mesh @mesh_4d(shape = ?x?x?x?)

  func.func @main() -> (index, tensor<2x2xi8>, tensor<1x2xi8>) {
    %idx = mesh.process_linear_index on @mesh0 : index
    
    %input = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>
    %broadcast_result = mesh.broadcast %input on @mesh1 
                      mesh_axes = [0] 
                      root = [0] : (tensor<2x2xi8>) -> tensor<2x2xi8>
    
    %scatter_result = mesh.scatter %broadcast_result on @mesh1 
                     mesh_axes = [0] 
                     scatter_axis = 0 
                     root = [1] : (tensor<2x2xi8>) -> tensor<1x2xi8>
    
    return %idx, %broadcast_result, %scatter_result : index, tensor<2x2xi8>, tensor<1x2xi8>
  }

  func.func @all_slice_op_lowering_of_dynamic_2d_tensor_on_dynamic_4d_mesh(
    %arg0 : tensor<?x?xf16>
  ) -> tensor<?x?xf16> {
    %0 = mesh.all_slice %arg0 on @mesh_4d mesh_axes = [3, 1] slice_axis = 1 : tensor<?x?xf16> -> tensor<?x?xf16>
    return %0 : tensor<?x?xf16>
  }
}