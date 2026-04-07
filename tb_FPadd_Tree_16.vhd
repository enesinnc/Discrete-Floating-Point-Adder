LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Konsola yazdýrma iþlemleri için
USE std.textio.all;
USE ieee.std_logic_textio.all;

-- bf19_pkg paketini dahil ediyoruz
USE work.bf19_pkg.all;

ENTITY tb_FPadd_Tree_16 IS
END tb_FPadd_Tree_16;

ARCHITECTURE behavior OF tb_FPadd_Tree_16 IS

    COMPONENT FPadd_Tree_16
    PORT(
         clk       : IN  std_logic;
         reset     : IN  std_logic;
         data_in   : IN  array_16x19;
         data_out  : OUT std_logic_vector(18 DOWNTO 0)
        );
    END COMPONENT;

    -- Sinyaller
    SIGNAL clk      : std_logic := '0';
    SIGNAL reset    : std_logic := '0';
    SIGNAL data_in  : array_16x19 := (OTHERS => (OTHERS => '0'));
    SIGNAL data_out : std_logic_vector(18 DOWNTO 0);

    CONSTANT clk_period : time := 10 ns;

    -- Test Sabitleri (1_8_10 formatýnda)
    CONSTANT BF19_ZERO  : std_logic_vector(18 DOWNTO 0) := "0000000000000000000"; -- 0.0
    CONSTANT BF19_P_ONE : std_logic_vector(18 DOWNTO 0) := "0011111110000000000"; -- +1.0
    CONSTANT BF19_M_ONE : std_logic_vector(18 DOWNTO 0) := "1011111110000000000"; -- -1.0
    CONSTANT BF19_TWO   : std_logic_vector(18 DOWNTO 0) := "0100000000000000000"; -- +2.0
    CONSTANT BF19_M_TWO : std_logic_vector(18 DOWNTO 0) := "1100000000000000000"; -- -2.0
    CONSTANT BF19_P_THR : std_logic_vector(18 DOWNTO 0) := "0100000001000000000"; -- +3.0 (Exp:128, Mant:1.5)
    
    -- Beklenen Sonuç Sabitleri
    CONSTANT BF19_P_4   : std_logic_vector(18 DOWNTO 0) := "0100000010000000000"; -- +4.0 (Exp:129)
    CONSTANT BF19_P_8   : std_logic_vector(18 DOWNTO 0) := "0100000100000000000"; -- +8.0 (Exp:130)
    CONSTANT BF19_P_16  : std_logic_vector(18 DOWNTO 0) := "0100000110000000000"; -- +16.0 (Exp:131)

BEGIN

    uut: FPadd_Tree_16 PORT MAP (
          clk      => clk,
          reset    => reset,
          data_in  => data_in,
          data_out => data_out
        );

    clk_process : PROCESS
    BEGIN
        clk <= '0';
        WAIT FOR clk_period/2;
        clk <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    stim_proc: PROCESS
        VARIABLE out_line : line;
    BEGIN
        reset <= '1';
        WAIT FOR clk_period * 5;
        reset <= '0';
        WAIT FOR clk_period * 2;

        -------------------------------------------------------------
        -- CASE 1: Bütün giriþler 0.0
        -------------------------------------------------------------
        REPORT "---------------------------------------------------";
        REPORT "Test Case 1: Butun girisler 0.0 uygulaniyor...";
        FOR i IN 0 TO 15 LOOP
            data_in(i) <= BF19_ZERO;
        END LOOP;
        WAIT FOR clk_period * 25;
        
        write(out_line, string'("Beklenen   : ")); write(out_line, BF19_ZERO); writeline(output, out_line);
        write(out_line, string'("Hesaplanan : ")); write(out_line, data_out); writeline(output, out_line);

        -------------------------------------------------------------
        -- CASE 2: Bütün giriþler +1.0 -> Toplam +16.0
        -------------------------------------------------------------
        REPORT "---------------------------------------------------";
        REPORT "Test Case 2: Butun girisler +1.0 uygulaniyor...";
        FOR i IN 0 TO 15 LOOP
            data_in(i) <= BF19_P_ONE;
        END LOOP;
        WAIT FOR clk_period * 25;
        
        write(out_line, string'("Beklenen   : ")); write(out_line, BF19_P_16); writeline(output, out_line);
        write(out_line, string'("Hesaplanan : ")); write(out_line, data_out); writeline(output, out_line);

        -------------------------------------------------------------
        -- CASE 3: 8x +1.0 ve 8x -1.0 -> Toplam 0.0
        -------------------------------------------------------------
        REPORT "---------------------------------------------------";
        REPORT "Test Case 3: 8x(+1.0) ve 8x(-1.0) uygulaniyor...";
        FOR i IN 0 TO 7 LOOP
            data_in(i) <= BF19_P_ONE;   
            data_in(i+8) <= BF19_M_ONE; 
        END LOOP;
        WAIT FOR clk_period * 25;
        
        write(out_line, string'("Beklenen   : ")); write(out_line, BF19_ZERO); writeline(output, out_line);
        write(out_line, string'("Hesaplanan : ")); write(out_line, data_out); writeline(output, out_line);

        -------------------------------------------------------------
        -- CASE 4: 1x +2.0 ve 15x 0.0 -> Toplam +2.0
        -------------------------------------------------------------
        REPORT "---------------------------------------------------";
        REPORT "Test Case 4: Sadece bir girise +2.0 uygulaniyor...";
        data_in(0) <= BF19_TWO;
        FOR i IN 1 TO 15 LOOP
            data_in(i) <= BF19_ZERO;
        END LOOP;
        WAIT FOR clk_period * 25;
        
        write(out_line, string'("Beklenen   : ")); write(out_line, BF19_TWO); writeline(output, out_line);
        write(out_line, string'("Hesaplanan : ")); write(out_line, data_out); writeline(output, out_line);

        -------------------------------------------------------------
        -- CASE 5: Zýt Ýþaretler A-B+C-D ... -> 8x(+2.0) ve 8x(-1.0) 
        -- Beklenen Toplam: 16.0 - 8.0 = +8.0
        -------------------------------------------------------------
        REPORT "---------------------------------------------------";
        REPORT "Test Case 5: A-B+C-D kombosu -> 8x(+2.0) ve 8x(-1.0)...";
        FOR i IN 0 TO 7 LOOP
            data_in(i*2)   <= BF19_TWO;   -- Çift portlara +2.0
            data_in(i*2+1) <= BF19_M_ONE; -- Tek portlara -1.0
        END LOOP;
        WAIT FOR clk_period * 25;
        
        write(out_line, string'("Beklenen   : ")); write(out_line, BF19_P_8); writeline(output, out_line);
        write(out_line, string'("Hesaplanan : ")); write(out_line, data_out); writeline(output, out_line);

        -------------------------------------------------------------
        -- CASE 6: Aðýr Çýkarma A-B-C-D ... -> 1x(+16.0) ve 15x(-1.0)
        -- Beklenen Toplam: 16.0 - 15.0 = +1.0
        -------------------------------------------------------------
        REPORT "---------------------------------------------------";
        REPORT "Test Case 6: A-B-C-D kombosu -> 1x(+16.0) ve 15x(-1.0)...";
        data_in(0) <= BF19_P_16;
        FOR i IN 1 TO 15 LOOP
            data_in(i) <= BF19_M_ONE;
        END LOOP;
        WAIT FOR clk_period * 25;
        
        write(out_line, string'("Beklenen   : ")); write(out_line, BF19_P_ONE); writeline(output, out_line);
        write(out_line, string'("Hesaplanan : ")); write(out_line, data_out); writeline(output, out_line);

        -------------------------------------------------------------
        -- CASE 7: Kesirli Karýþýk A+B-C ... -> 4x(+3.0) + 4x(-2.0) + 8x(0.0)
        -- Beklenen Toplam: 12.0 - 8.0 = +4.0
        -------------------------------------------------------------
        REPORT "---------------------------------------------------";
        REPORT "Test Case 7: Kesirli Karisik -> 4x(+3.0), 4x(-2.0) ve 8x(0.0)...";
        FOR i IN 0 TO 3 LOOP
            data_in(i) <= BF19_P_THR;
        END LOOP;
        FOR i IN 4 TO 7 LOOP
            data_in(i) <= BF19_M_TWO;
        END LOOP;
        FOR i IN 8 TO 15 LOOP
            data_in(i) <= BF19_ZERO;
        END LOOP;
        WAIT FOR clk_period * 25;
        
        write(out_line, string'("Beklenen   : ")); write(out_line, BF19_P_4); writeline(output, out_line);
        write(out_line, string'("Hesaplanan : ")); write(out_line, data_out); writeline(output, out_line);
        
        REPORT "---------------------------------------------------";
        REPORT "Tum test senaryolari basariyla uygulandi.";
        WAIT;
    END PROCESS;

END behavior;