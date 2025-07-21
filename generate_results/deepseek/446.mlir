module {
  func.func @get_constant() -> index {
    %c = index.constant 42
    return %c : index
  }

  func.func @compute_remainder(%a: index, %b: index) -> index {
    %rem = index.rems %a, %b
    return %rem : index
  }

  func.func @ceildivs() -> (index, index, index) {
    %c0 = index.constant 0
    %c2 = index.constant 2
    %c5 = index.constant 5
    %0 = index.ceildivs %c0, %c5
    %1 = index.ceildivs %c2, %c5
    %2 = index.ceildivs %c5, %c2
    return %0, %1, %2 : index, index, index
  }

  func.func @main(%a: index, %b: index) -> (index, index, index, index) {
    %constant = call @get_constant() : () -> index
    
    %remainder = call @compute_remainder(%a, %b) : (index, index) -> index
    
    %result = index.shrs %remainder, %b

    %div0, %div1, %div2 = call @ceildivs() : () -> (index, index, index)
    
    return %result, %div0, %div1, %div2 : index, index, index, index
  }
}