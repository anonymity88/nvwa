module {
  func.func @main() -> () {
    // Call the declare_target functions with link and to capture clauses
    func.call @omp_decl_tar_any_link() : () -> ()
    func.call @omp_decl_tar_any_to() : () -> ()
    return
  }

  func.func @omp_decl_tar_any_link() -> () attributes {omp.declare_target = #omp.declaretarget<device_type = (any), capture_clause = (link)>} {
    return
  }

  func.func @omp_decl_tar_any_to() -> () attributes {omp.declare_target = #omp.declaretarget<device_type = (any), capture_clause = (to)>} {
    return
  }
}