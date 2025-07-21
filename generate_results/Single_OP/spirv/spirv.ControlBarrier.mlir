module {
  func.func @main() {
    spirv.ControlBarrier #spirv.scope<Workgroup>, #spirv.scope<Device>, #spirv.memory_semantics<Acquire|UniformMemory>
    return
  }
}