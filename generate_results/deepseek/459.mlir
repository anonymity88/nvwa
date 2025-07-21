!mat32f32 = !llvm.struct<(
  f32, f32, f32, f32, f32, f32, f32, f32, 
  f32, f32, f32, f32, f32, f32, f32, f32, 
  f32, f32, f32, f32, f32, f32, f32, f32, 
  f32, f32, f32, f32, f32, f32, f32, f32)>

module {
  func.func @wgmma_f32_e5m2_e4m3(%descA : i64, %descB : i64) -> !mat32f32 {  
    %result = llvm.mlir.undef : !mat32f32
    %result1 = nvvm.wgmma.mma_async %descA, %descB, %result,
        #nvvm.shape<m = 64, n = 64, k = 32>, 
        D [#nvvm.wgmma_type<f32>, #nvvm.wgmma_scale_out<one>],
        A [#nvvm.wgmma_type<e5m2>, #nvvm.wgmma_scale_in<one>, #nvvm.mma_layout<row>], 
        B [#nvvm.wgmma_type<e4m3>, #nvvm.wgmma_scale_in<one>, #nvvm.mma_layout<col>]
        : !mat32f32 -> !mat32f32
    %result2 = nvvm.wgmma.mma_async %descA, %descB, %result1,
        #nvvm.shape<m = 64, n = 64, k = 32>, 
        D [#nvvm.wgmma_type<f32>, #nvvm.wgmma_scale_out<one>],
        A [#nvvm.wgmma_type<e5m2>, #nvvm.wgmma_scale_in<one>, #nvvm.mma_layout<row>], 
        B [#nvvm.wgmma_type<e4m3>, #nvvm.wgmma_scale_in<one>, #nvvm.mma_layout<col>]
        : !mat32f32 -> !mat32f32
    return %result2 : !mat32f32
  }

  func.func @wgmma_f32_e4m3_e4m3(%descA : i64, %descB : i64) -> !mat32f32 {  
    %result = llvm.mlir.undef : !mat32f32
    %result1 = nvvm.wgmma.mma_async %descA, %descB, %result,
        #nvvm.shape<m = 64, n = 64, k = 32>, 
        D [#nvvm.wgmma_type<f32>, #nvvm.wgmma_scale_out<one>],
        A [#nvvm.wgmma_type<e4m3>, #nvvm.wgmma_scale_in<one>, #nvvm.mma_layout<row>], 
        B [#nvvm.wgmma_type<e4m3>, #nvvm.wgmma_scale_in<one>, #nvvm.mma_layout<col>]
        : !mat32f32 -> !mat32f32
    %result2 = nvvm.wgmma.mma_async %descA, %descB, %result1,
        #nvvm.shape<m = 64, n = 64, k = 32>, 
        D [#nvvm.wgmma_type<f32>, #nvvm.wgmma_scale_out<one>],
        A [#nvvm.wgmma_type<e4m3>, #nvvm.wgmma_scale_in<one>, #nvvm.mma_layout<row>], 
        B [#nvvm.wgmma_type<e4m3>, #nvvm.wgmma_scale_in<one>, #nvvm.mma_layout<col>]
        : !mat32f32 -> !mat32f32
    return %result2 : !mat32f32
  }

  func.func @main(%descA : i64, %descB : i64) -> !mat32f32 {
    // Call both wgmma operations and combine their results
    %result_e5m2 = call @wgmma_f32_e5m2_e4m3(%descA, %descB) : (i64, i64) -> !mat32f32
    %result_e4m3 = call @wgmma_f32_e4m3_e4m3(%descA, %descB) : (i64, i64) -> !mat32f32
    
    // Here we could add operations to combine the results if needed
    // For now, just return the first result
    return %result_e5m2 : !mat32f32
  }
}