LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-- Kendi veri tipimizi tanımladığımız paket
PACKAGE bf19_pkg IS
    TYPE array_16x19 IS ARRAY (0 TO 15) OF std_logic_vector(18 DOWNTO 0);
    TYPE array_8x19  IS ARRAY (0 TO 7) OF std_logic_vector(18 DOWNTO 0);
    TYPE array_4x19  IS ARRAY (0 TO 3) OF std_logic_vector(18 DOWNTO 0);
    TYPE array_2x19  IS ARRAY (0 TO 1) OF std_logic_vector(18 DOWNTO 0);
END PACKAGE bf19_pkg;

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE work.bf19_pkg.all;

ENTITY FPadd_Tree_16 IS
    PORT(
        clk       : IN  std_logic;
        reset     : IN  std_logic;
        data_in   : IN  array_16x19;
        data_out  : OUT std_logic_vector(18 DOWNTO 0)
    );
END FPadd_Tree_16;

ARCHITECTURE structural OF FPadd_Tree_16 IS

    COMPONENT FPadd_bf19
       PORT( 
          ADD_SUB : IN     std_logic;
          FP_A    : IN     std_logic_vector (18 DOWNTO 0);
          FP_B    : IN     std_logic_vector (18 DOWNTO 0);
          clk     : IN     std_logic;
          FP_Z    : OUT    std_logic_vector (18 DOWNTO 0)
       );
    END COMPONENT;

    SIGNAL level1_out : array_8x19;
    SIGNAL level2_out : array_4x19;
    SIGNAL level3_out : array_2x19;

BEGIN

    --=========================================
    -- SEVİYE 1: 16 Giriş -> 8 Çıkış
    --=========================================
    GEN_LEVEL1: FOR i IN 0 TO 7 GENERATE
        ADD_L1: FPadd_bf19
            PORT MAP(
                ADD_SUB => '1', -- DÜZELTİLDİ: '1' Toplama işlemi içindir
                FP_A    => data_in(i*2),
                FP_B    => data_in(i*2 + 1),
                clk     => clk,
                FP_Z    => level1_out(i)
            );
    END GENERATE GEN_LEVEL1;

    --=========================================
    -- SEVİYE 2: 8 Giriş -> 4 Çıkış
    --=========================================
    GEN_LEVEL2: FOR i IN 0 TO 3 GENERATE
        ADD_L2: FPadd_bf19
            PORT MAP(
                ADD_SUB => '1', -- DÜZELTİLDİ
                FP_A    => level1_out(i*2),
                FP_B    => level1_out(i*2 + 1),
                clk     => clk,
                FP_Z    => level2_out(i)
            );
    END GENERATE GEN_LEVEL2;

    --=========================================
    -- SEVİYE 3: 4 Giriş -> 2 Çıkış
    --=========================================
    GEN_LEVEL3: FOR i IN 0 TO 1 GENERATE
        ADD_L3: FPadd_bf19
            PORT MAP(
                ADD_SUB => '1', -- DÜZELTİLDİ
                FP_A    => level2_out(i*2),
                FP_B    => level2_out(i*2 + 1),
                clk     => clk,
                FP_Z    => level3_out(i)
            );
    END GENERATE GEN_LEVEL3;

    --=========================================
    -- SEVİYE 4: 2 Giriş -> 1 Nihai Çıkış
    --=========================================
    ADD_L4: FPadd_bf19
        PORT MAP(
            ADD_SUB => '1', -- DÜZELTİLDİ
            FP_A    => level3_out(0),
            FP_B    => level3_out(1),
            clk     => clk,
            FP_Z    => data_out
        );

END structural;