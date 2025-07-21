module {
  func.func @main() {
    // Call gpu.num_subgroups to get the number of subgroups in the current workgroup
    %numSg = gpu.num_subgroups : index

    return
  }
}