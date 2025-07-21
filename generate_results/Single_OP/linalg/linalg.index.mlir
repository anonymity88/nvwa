#map = affine_map<(i, j) -> (i, j)>

module {
  func.func @main(%I: memref<?x?xindex>, %J: memref<?x?xindex>) {
    linalg.generic {indexing_maps = [#map, #map],
                    iterator_types = ["parallel", "parallel"]}
      outs(%I, %J : memref<?x?xindex>, memref<?x?xindex>) {
      ^bb0(%arg0 : index, %arg1 : index):
        // Access the outer iteration dimension i
        %i = linalg.index 0 : index
        // Access the inner iteration dimension j
        %j = linalg.index 1 : index
        linalg.yield %i, %j : index, index
    }
    
    return
  }
}