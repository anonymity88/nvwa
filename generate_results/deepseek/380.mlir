module {
  mesh.mesh @mesh0(shape = 2x2)
  mesh.mesh @mesh1(shape = 3x4x5)
  mesh.mesh @mesh_1d(shape = 4)

  func.func @main() -> (tensor<2x2xi8>, index, index, index, tensor<1x2xi8>) {
    %input = arith.constant dense<[[1, 2], [3, 4]]> : tensor<2x2xi8>
    %broadcast_result = mesh.broadcast %input on @mesh0 
                      mesh_axes = [0] 
                      root = [0] : (tensor<2x2xi8>) -> tensor<2x2xi8>

    %d0, %d1, %d2 = mesh.mesh_shape @mesh1 : index, index, index

    %scatter_result = mesh.scatter %broadcast_result on @mesh0 
                     mesh_axes = [0] 
                     scatter_axis = 0 
                     root = [1] : (tensor<2x2xi8>) -> tensor<1x2xi8>

    return %broadcast_result, %d0, %d1, %d2, %scatter_result : tensor<2x2xi8>, index, index, index, tensor<1x2xi8>
  }

  func.func @matmul_1d_mesh_static_tensors_parallel_iterator_unsplit_last_axis(
    %in1: tensor<4x6xi8>,
    %in2: tensor<6x8xi8>,
    %dps_out: tensor<4x8xi8>
  ) -> tensor<4x8xi8> {
    %sharding1 = mesh.sharding @mesh_1d split_axes = [[], []] : !mesh.sharding
    %in1_replicated1 = mesh.shard %in1 to %sharding1 : tensor<4x6xi8>
    %in1_replicated2 = mesh.shard %in1_replicated1 to %sharding1 annotate_for_users : tensor<4x6xi8>
    %in2_replicated = mesh.shard %in2 to %sharding1 : tensor<6x8xi8>
    %sharding2 = mesh.sharding @mesh_1d split_axes = [[], [0]] : !mesh.sharding
    %in2_sharded = mesh.shard %in2_replicated to %sharding2 annotate_for_users : tensor<6x8xi8>
    %dps_out_replicated = mesh.shard %dps_out to %sharding1 : tensor<4x8xi8>
    %dps_out_sharded = mesh.shard %dps_out_replicated to %sharding2 annotate_for_users : tensor<4x8xi8>
    %res = linalg.matmul ins(%in1_replicated2, %in2_sharded : tensor<4x6xi8>, tensor<6x8xi8>)
        outs(%dps_out_sharded : tensor<4x8xi8>) -> tensor<4x8xi8>
    %res_sharded = mesh.shard %res to %sharding2 : tensor<4x8xi8>
    %res_replicated = mesh.shard %res_sharded to %sharding1 annotate_for_users : tensor<4x8xi8>
    return %res_replicated : tensor<4x8xi8>
  }
}