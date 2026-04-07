# Discrete-Floating-Point-Adder

## Credits and Acknowledgments

This design is a modified version of the original work by Marcus, Guillermo, which can be found at [https://opencores.org/projects/fpuvhdl](https://opencores.org/projects/fpuvhdl). 

### Key Modifications:
* **Architecture:** Adapted into a **16-input binary adder tree**.
* **Data Format:** Customized for the **BF19** (Bfloat19) format, featuring:
    * **8-bit** Exponent
    * **10-bit** Mantissa


### Test Results:

# run 1000ns
Note: ---------------------------------------------------
Time: 70 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Note: Test Case 1: Butun girisler 0.0 uygulaniyor...
Time: 70 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Beklenen   : 0000000000000000000
Hesaplanan : 0000000000000000000
Note: ---------------------------------------------------
Time: 320 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Note: Test Case 2: Butun girisler +1.0 uygulaniyor...
Time: 320 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Beklenen   : 0100000110000000000
Hesaplanan : 0100000110000000000
Note: ---------------------------------------------------
Time: 570 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Note: Test Case 3: 8x(+1.0) ve 8x(-1.0) uygulaniyor...
Time: 570 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Beklenen   : 0000000000000000000
Hesaplanan : 0000000000000000000
Note: ---------------------------------------------------
Time: 820 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Note: Test Case 4: Sadece bir girise +2.0 uygulaniyor...
Time: 820 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
INFO: [USF-XSim-96] XSim completed. Design snapshot 'tb_FPadd_Tree_16_behav' loaded.
INFO: [USF-XSim-97] XSim simulation ran for 1000ns
launch_simulation: Time (s): cpu = 00:00:05 ; elapsed = 00:00:07 . Memory (MB): peak = 1255.000 ; gain = 0.000
run 10 us
Beklenen   : 0100000000000000000
Hesaplanan : 0100000000000000000
Note: ---------------------------------------------------
Time: 1070 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Note: Test Case 5: A-B+C-D kombosu -> 8x(+2.0) ve 8x(-1.0)...
Time: 1070 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Beklenen   : 0100000100000000000
Hesaplanan : 0100000100000000000
Note: ---------------------------------------------------
Time: 1320 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Note: Test Case 6: A-B-C-D kombosu -> 1x(+16.0) ve 15x(-1.0)...
Time: 1320 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Beklenen   : 0011111110000000000
Hesaplanan : 0011111110000000000
Note: ---------------------------------------------------
Time: 1570 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Note: Test Case 7: Kesirli Karisik -> 4x(+3.0), 4x(-2.0) ve 8x(0.0)...
Time: 1570 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Beklenen   : 0100000010000000000
Hesaplanan : 0100000010000000000
Note: ---------------------------------------------------
Time: 1820 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
Note: Tum test senaryolari basariyla uygulandi.
Time: 1820 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  File: C:/Users/pc/VHDL_hazirlik/discrete_floating_point_adder/discrete_floating_point_adder.srcs/sim_1/new/tb_FPadd_Tree_16.vhd
