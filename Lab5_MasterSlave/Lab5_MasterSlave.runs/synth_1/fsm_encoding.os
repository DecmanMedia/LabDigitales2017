
 add_fsm_encoding \
       {pb_debouncer.button_state} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} {100 100} }

 add_fsm_encoding \
       {TX_control.state} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} {100 100} {101 101} }

 add_fsm_encoding \
       {uart_rx.state} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} {100 100} }

 add_fsm_encoding \
       {display_mux.ss_select_q} \
       { }  \
       {{00000000 0000} {00000001 0001} {00000010 0010} {00000100 0011} {00001000 0100} {00010000 0101} {00100000 0110} {01000000 0111} {10000000 1000} }

 add_fsm_encoding \
       {UART_RX_CTRL.state} \
       { }  \
       {{0001 0000} {0010 0001} {0011 0010} {0100 0011} {0101 0100} {0110 0101} {0111 0110} {1000 0111} {1001 1000} {1010 1001} {1011 1010} {1100 1011} }

 add_fsm_encoding \
       {lab_4.estado_actual} \
       { }  \
       {{001 00} {011 01} {101 10} {111 11} }
