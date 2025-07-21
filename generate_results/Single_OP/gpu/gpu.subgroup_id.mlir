module {
  func.func @main() {
    // Acquire the subgroup ID within the current workgroup.
    %sgId = gpu.subgroup_id : index

    return
  }
}