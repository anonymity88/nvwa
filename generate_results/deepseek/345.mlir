module {
  mesh.mesh @mesh0(shape = 10x20x30)
  mesh.mesh @mesh1(shape = 4x8)
  mesh.mesh @mesh2(shape = 2x2)
  mesh.mesh @mesh_1d(shape = ?)

  func.func @main(%arg0 : tensor<4x8xf32>, %input : tensor<2x2xi8>) -> (index, tensor<1x2xi8>) {
    %idx = mesh.process_linear_index on @mesh0 : index

    %sharding = mesh.sharding @mesh1 split_axes = [[0]] : !mesh.sharding
    %0 = mesh.shard %arg0 to %sharding : tensor<4x8xf32>

    %result = mesh.scatter %input on @mesh2 
                     mesh_axes = [0] 
                     scatter_axis = 0 
                     root = [1] : (tensor<2x2xi8>) -> tensor<1x2xi8>

    return %idx, %result : index, tensor<1x2xi8>
  }

  func.func @all_slice_op_lowering_of_dynamic_1d_tensor_on_dynamic_1d_mesh(
    %arg0: tensor<?xf16>
  ) -> tensor<?xf16> {
    %0 = mesh.all_slice %arg0 on @mesh_1d mesh_axes = [0] slice_axis = 0 : tensor<?xf16> -> tensor<?xf16>
    return %0 : tensor<?xf16>
  }
}