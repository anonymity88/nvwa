#ID_MAP = affine_map<(d0, d1) -> (d0, d1)>
#BSR = #sparse_tensor.encoding<{
  map = ( i, j ) ->
  ( i floordiv 2 : dense,
    j floordiv 3 : compressed,
    i mod 2      : dense,
    j mod 3      : dense
  )
}>
module {
  func.func @main(%arg0: index, %arg1: memref<100xindex>, %arg2: memref<?xf32>, %arg3: memref<10xi32>, %arg4: index, %arg5: index) -> (memref<100xindex>, memref<?xf32>, memref<10xi32>, index, index) {
    %0, %1, %2 = call @sparse_sort_coo_heap(%arg0, %arg1, %arg2, %arg3) : (index, memref<100xindex>, memref<?xf32>, memref<10xi32>) -> (memref<100xindex>, memref<?xf32>, memref<10xi32>)
    %3, %4 = call @sparse_crd_translate(%arg4, %arg5) : (index, index) -> (index, index)
    return %0, %1, %2, %3, %4 : memref<100xindex>, memref<?xf32>, memref<10xi32>, index, index
  }

  func.func @sparse_sort_coo_heap(%arg0: index, %arg1: memref<100xindex>, %arg2: memref<?xf32>, %arg3: memref<10xi32>) -> (memref<100xindex>, memref<?xf32>, memref<10xi32>) {
    sparse_tensor.sort heap_sort %arg0, %arg1 jointly %arg2, %arg3 {perm_map = #ID_MAP, ny = 1: index} : memref<100xindex> jointly memref<?xf32>, memref<10xi32>
    return %arg1, %arg2, %arg3 : memref<100xindex>, memref<?xf32>, memref<10xi32>
  }

  func.func @sparse_crd_translate(%arg0: index, %arg1: index) -> (index, index) {
    %l0, %l1, %l2, %l3 = sparse_tensor.crd_translate dim_to_lvl [%arg0, %arg1] as #BSR : index, index, index, index
    %d0, %d1 = sparse_tensor.crd_translate lvl_to_dim [%l0, %l1, %l2, %l3] as #BSR : index, index
    return %d0, %d1 : index, index
  }
}