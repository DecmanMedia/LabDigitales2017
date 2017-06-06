-makelib ies/xil_defaultlib -sv \
  "C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \
-endlib
-makelib ies/xpm \
  "C:/Xilinx/Vivado/2016.4/data/ip/xpm/xpm_VCOMP.vhd" \
-endlib
-makelib ies/xil_defaultlib \
  "../../../../Lab_Saleae_1.0.srcs/sources_1/ip/clk_nuevo/clk_nuevo_clk_wiz.v" \
  "../../../../Lab_Saleae_1.0.srcs/sources_1/ip/clk_nuevo/clk_nuevo.v" \
-endlib
-makelib ies/xil_defaultlib \
  glbl.v
-endlib

