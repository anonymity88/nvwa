module {
  func.func @main(%pointer: !spirv.ptr<i32, Workgroup>, %value: i32, %comparator: i32) -> i32 {
    %original_value = spirv.AtomicCompareExchange <Workgroup> <Acquire> <None>
                                      %pointer, %value, %comparator
                                      : !spirv.ptr<i32, Workgroup>
    return %original_value : i32
  }

  func.func @example_atomic_compare_exchange(%pointer: !spirv.ptr<i32, Workgroup>, %value: i32, %comparator: i32) -> i32 {
    %original_value = spirv.AtomicCompareExchange <Workgroup> <Acquire> <None>
                                      %pointer, %value, %comparator
                                      : !spirv.ptr<i32, Workgroup>
    return %original_value : i32
  }
}