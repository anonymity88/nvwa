module {
  func.func @main() {
    // Perform a vector step operation to generate a sequence of index values
    %step_vector = vector.step : vector<4xindex>

    return
  }
}