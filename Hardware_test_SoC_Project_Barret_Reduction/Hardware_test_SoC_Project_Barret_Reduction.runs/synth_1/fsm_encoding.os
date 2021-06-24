
 add_fsm_encoding \
       {spi_ctrl.current_state} \
       { }  \
       {{00 0001} {01 0010} {10 0100} {11 1000} }

 add_fsm_encoding \
       {delay.current_state} \
       { }  \
       {{00 00} {01 01} {10 10} {11 11} }
