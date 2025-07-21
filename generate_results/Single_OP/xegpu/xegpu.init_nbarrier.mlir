module {
  func.func @main() -> !xegpu.nbarrier {
    %nbarrier_id = arith.constant 5 : i8
    %participant_thread_num = arith.constant 8 : i8
    %nbarrier = xegpu.init_nbarrier %nbarrier_id, %participant_thread_num : i8, i8 -> !xegpu.nbarrier
    return %nbarrier : !xegpu.nbarrier
  }
}