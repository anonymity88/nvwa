module {
  func.func @main(%pointer: !spirv.ptr<i32, Workgroup>, %value: i32, %comparator: i32) -> i32 {
    %result = spirv.AtomicCompareExchangeWeak <Workgroup> <Acquire> <None> %pointer, %value, %comparator : !spirv.ptr<i32, Workgroup>
    return %result : i32
  }

  func.func @example_compare_exchange(%ptr: !spirv.ptr<i32, Workgroup>, %val: i32, %comp: i32) -> i32 {
    %result = spirv.AtomicCompareExchangeWeak <Workgroup> <Acquire> <None> %ptr, %val, %comp : !spirv.ptr<i32, Workgroup>
    return %result : i32
  }
}