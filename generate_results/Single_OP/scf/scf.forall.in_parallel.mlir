#map = affine_map<(d0, d1) -> (d0, d1)>

module {
  func.func @parallel_matrix_mul(%A: tensor<?x?xf32>, %B: tensor<?x?xf32>, %dim: index,
                               %tileSize: index) -> tensor<?x?xf32> {
    // Initialize the output tensor
    %out = tensor.empty(%dim, %dim) : tensor<?x?xf32>

    // Perform parallel matrix multiplication using scf.forall
    %result = scf.forall (%i, %j) = (0, 0) to (%dim, %dim) 
        step (%tileSize, %tileSize) shared_outs(%o = %out) -> (tensor<?x?xf32>) {
      
      // Extract slices for the current tile
      %sA = tensor.extract_slice %A[%i, %j][%tileSize, %tileSize][1, 1] : tensor<?x?xf32> to tensor<?x?xf32>
      %sB = tensor.extract_slice %B[%i, %j][%tileSize, %tileSize][1, 1] : tensor<?x?xf32> to tensor<?x?xf32>
      %sC = tensor.extract_slice %o[%i, %j][%tileSize, %tileSize][1, 1] : tensor<?x?xf32> to tensor<?x?xf32>

      // Matrix multiplication using linalg.generic
      %matmulC = linalg.generic
        { indexing_maps = [#map, #map, #map], iterator_types = ["parallel", "parallel"] }
        ins(%sA, %sB : tensor<?x?xf32>, tensor<?x?xf32>)
        outs(%sC : tensor<?x?xf32>) {
          ^bb0(%a: f32, %b: f32, %c: f32):
            %mul = arith.mulf %a, %b : f32
            %sum = arith.addf %mul, %c : f32
            linalg.yield %sum : f32
        } -> tensor<?x?xf32>

      // Ensure results are committed back into the shared output
      scf.forall.in_parallel {
        tensor.parallel_insert_slice %matmulC into %o[%i, %j][%tileSize, %tileSize][1, 1] : tensor<?x?xf32> into tensor<?x?xf32>
      }
    }
    
    return %result : tensor<?x?xf32>
  }
}