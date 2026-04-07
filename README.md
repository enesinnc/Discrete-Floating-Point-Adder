# Discrete-Floating-Point-Adder

## Credits and Acknowledgments

This design is a modified version of the original work by Marcus, Guillermo, which can be found at [https://opencores.org/projects/fpuvhdl](https://opencores.org/projects/fpuvhdl). 

### Key Modifications:
* **Architecture:** Adapted into a **16-input binary adder tree**.
* **Data Format:** Customized for the **BF19** (Bfloat19) format, featuring:
    * **8-bit** Exponent
    * **10-bit** Mantissa


### Test Results:
# Simulation Output (Vivado XSim)
# Run Length: 1000ns + 10us

Note: ---------------------------------------------------
Time: 70 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  
Note: Test Case 1: Butun girisler 0.0 uygulaniyor...
Beklenen   : 0000000000000000000
Hesaplanan : 0000000000000000000

Note: ---------------------------------------------------
Time: 320 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  
Note: Test Case 2: Butun girisler +1.0 uygulaniyor...
Beklenen   : 0100000110000000000
Hesaplanan : 0100000110000000000

Note: ---------------------------------------------------
Time: 570 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  
Note: Test Case 3: 8x(+1.0) ve 8x(-1.0) uygulaniyor...
Beklenen   : 0000000000000000000
Hesaplanan : 0000000000000000000

Note: ---------------------------------------------------
Time: 820 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  
Note: Test Case 4: Sadece bir girise +2.0 uygulaniyor...
Beklenen   : 0100000000000000000
Hesaplanan : 0100000000000000000

Note: ---------------------------------------------------
Time: 1070 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  
Note: Test Case 5: A-B+C-D kombosu -> 8x(+2.0) ve 8x(-1.0)...
Beklenen   : 0100000100000000000
Hesaplanan : 0100000100000000000

Note: ---------------------------------------------------
Time: 1320 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  
Note: Test Case 6: A-B-C-D kombosu -> 1x(+16.0) ve 15x(-1.0)...
Beklenen   : 0011111110000000000
Hesaplanan : 0011111110000000000

Note: ---------------------------------------------------
Time: 1570 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  
Note: Test Case 7: Kesirli Karisik -> 4x(+3.0), 4x(-2.0) ve 8x(0.0)...
Beklenen   : 0100000010000000000
Hesaplanan : 0100000010000000000

Note: ---------------------------------------------------
Time: 1820 ns  Iteration: 0  Process: /tb_FPadd_Tree_16/stim_proc  
Note: Tum test senaryolari basariyla uygulandi.
---------------------------------------------------
