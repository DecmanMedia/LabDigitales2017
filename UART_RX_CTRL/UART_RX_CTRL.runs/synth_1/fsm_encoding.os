
 add_fsm_encoding \
       {uart_rx.state} \
       { }  \
       {{000 000} {001 001} {010 010} {011 011} {100 100} }

 add_fsm_encoding \
       {UART_RX_CTRL.state} \
       { }  \
       {{0001 0000} {0010 0001} {0011 0010} {0100 0011} {0101 0100} {0110 0101} {0111 0110} {1000 0111} {1001 1000} {1010 1001} {1011 1010} {1100 1011} }
