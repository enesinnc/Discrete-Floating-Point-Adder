-- FPadd_stage4.vhd --
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY FPadd_stage4 IS
   PORT( 
      A_SIGN_stage3    : IN  std_logic;
      B_XSIGN_stage3   : IN  std_logic;
      EXP_base         : IN  std_logic_vector (7 DOWNTO 0);
      add_out          : IN  std_logic_vector (15 DOWNTO 0);
      clk              : IN  std_logic;
      isINF_tab_stage3 : IN  std_logic;
      isNaN_stage3     : IN  std_logic;
      isZ_tab_stage3   : IN  std_logic;
      EXP_norm         : OUT std_logic_vector (7 DOWNTO 0);
      OV_stage4        : OUT std_logic;
      SIG_norm         : OUT std_logic_vector (14 DOWNTO 0);
      Z_SIGN_stage4    : OUT std_logic;
      isINF_tab_stage4 : OUT std_logic;
      isNaN_stage4     : OUT std_logic;
      isZ_tab_stage4   : OUT std_logic;
      zero_stage4      : OUT std_logic
   );
END FPadd_stage4 ;

ARCHITECTURE struct OF FPadd_stage4 IS
   SIGNAL EXP_norm_int : std_logic_vector(7 DOWNTO 0);
   SIGNAL EXP_selC     : std_logic_vector(7 DOWNTO 0);
   SIGNAL OV           : std_logic;
   SIGNAL SIG_norm_int : std_logic_vector(14 DOWNTO 0);
   SIGNAL SIG_selC     : std_logic_vector(14 DOWNTO 0);
   SIGNAL Z_SIGN       : std_logic;
   SIGNAL add_out_sign : std_logic;
   SIGNAL zero         : std_logic;

   COMPONENT FPadd_normalize
   PORT (
      EXP_in  : IN  std_logic_vector (7 DOWNTO 0);
      SIG_in  : IN  std_logic_vector (14 DOWNTO 0);
      EXP_out : OUT std_logic_vector (7 DOWNTO 0);
      SIG_out : OUT std_logic_vector (14 DOWNTO 0);
      zero    : OUT std_logic 
   );
   END COMPONENT;

   COMPONENT FPselComplement
   GENERIC ( SIG_width : integer := 15 );
   PORT (
      SIG_in  : IN  std_logic_vector (SIG_width DOWNTO 0);
      EXP_in  : IN  std_logic_vector (7 DOWNTO 0);
      SIG_out : OUT std_logic_vector (SIG_width-1 DOWNTO 0);
      EXP_out : OUT std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;
BEGIN
   PROCESS(clk)
   BEGIN
      IF RISING_EDGE(clk) THEN
         Z_SIGN_stage4 <= Z_SIGN; OV_stage4 <= OV; EXP_norm <= EXP_norm_int; SIG_norm <= SIG_norm_int;
         zero_stage4 <= zero; isINF_tab_stage4 <= isINF_tab_stage3; isNaN_stage4 <= isNaN_stage3; isZ_tab_stage4 <= isZ_tab_stage3;
      END IF;
   END PROCESS;

   add_out_sign <= add_out(15);

   SignLogic_truth_process: PROCESS(A_SIGN_stage3, B_XSIGN_stage3, add_out_sign)
      VARIABLE b1_A_SIGN_stage3B_XSIGN_stage3add_out_sign : std_logic_vector(2 DOWNTO 0);
   BEGIN
      b1_A_SIGN_stage3B_XSIGN_stage3add_out_sign := A_SIGN_stage3 & B_XSIGN_stage3 & add_out_sign;
      CASE b1_A_SIGN_stage3B_XSIGN_stage3add_out_sign IS
      WHEN "000" => OV <= '0'; Z_SIGN <= '0';
      WHEN "001" => OV <= '1'; Z_SIGN <= '0';
      WHEN "010" => OV <= '0'; Z_SIGN <= '0';
      WHEN "011" => OV <= '0'; Z_SIGN <= '1';
      WHEN "100" => OV <= '0'; Z_SIGN <= '0';
      WHEN "101" => OV <= '0'; Z_SIGN <= '1';
      WHEN "110" => OV <= '0'; Z_SIGN <= '1';
      WHEN "111" => OV <= '1'; Z_SIGN <= '1';
      WHEN OTHERS => OV <= '0'; Z_SIGN <= '0';
      END CASE;
   END PROCESS SignLogic_truth_process;

   I8 : FPadd_normalize PORT MAP (EXP_in=>EXP_selC, SIG_in=>SIG_selC, EXP_out=>EXP_norm_int, SIG_out=>SIG_norm_int, zero=>zero);
   I12 : FPselComplement GENERIC MAP (SIG_width=>15) PORT MAP (SIG_in=>add_out, EXP_in=>EXP_base, SIG_out=>SIG_selC, EXP_out=>EXP_selC);
END struct;