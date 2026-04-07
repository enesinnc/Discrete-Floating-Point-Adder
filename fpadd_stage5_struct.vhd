-- FPadd_stage5.vhd --
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY FPadd_stage5 IS
   PORT( 
      EXP_norm         : IN  std_logic_vector (7 DOWNTO 0);
      OV_stage4        : IN  std_logic;
      SIG_norm         : IN  std_logic_vector (14 DOWNTO 0);
      Z_SIGN_stage4    : IN  std_logic;
      clk              : IN  std_logic;
      isINF_tab_stage4 : IN  std_logic;
      isNaN_stage4     : IN  std_logic;
      isZ_tab_stage4   : IN  std_logic;
      zero_stage4      : IN  std_logic;
      OV               : OUT std_logic;
      SIG_norm2        : OUT std_logic_vector (14 DOWNTO 0);
      Z_EXP            : OUT std_logic_vector (7 DOWNTO 0);
      Z_SIGN           : OUT std_logic;
      isINF_tab        : OUT std_logic;
      isNaN            : OUT std_logic;
      isZ_tab          : OUT std_logic;
      zero             : OUT std_logic
   );
END FPadd_stage5 ;

ARCHITECTURE struct OF FPadd_stage5 IS
   SIGNAL EXP_round_int : std_logic_vector(7 DOWNTO 0);
   SIGNAL SIG_norm2_int : std_logic_vector(14 DOWNTO 0);
   SIGNAL SIG_round_int : std_logic_vector(14 DOWNTO 0);
   SIGNAL Z_EXP_int     : std_logic_vector(7 DOWNTO 0);

   COMPONENT FPnormalize
   GENERIC ( SIG_width : integer := 15 );
   PORT (
      SIG_in  : IN  std_logic_vector (SIG_width-1 DOWNTO 0);
      EXP_in  : IN  std_logic_vector (7 DOWNTO 0);
      SIG_out : OUT std_logic_vector (SIG_width-1 DOWNTO 0);
      EXP_out : OUT std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT FPround
   GENERIC ( SIG_width : integer := 15 );
   PORT (
      SIG_in  : IN  std_logic_vector (SIG_width-1 DOWNTO 0);
      EXP_in  : IN  std_logic_vector (7 DOWNTO 0);
      SIG_out : OUT std_logic_vector (SIG_width-1 DOWNTO 0);
      EXP_out : OUT std_logic_vector (7 DOWNTO 0)
   );
   END COMPONENT;
BEGIN
   PROCESS(clk)
   BEGIN
      IF RISING_EDGE(clk) THEN
         Z_EXP <= Z_EXP_int; SIG_norm2 <= SIG_norm2_int; Z_SIGN <= Z_SIGN_stage4; OV <= OV_stage4;
         zero <= zero_stage4; isINF_tab <= isINF_tab_stage4; isNaN <= isNaN_stage4; isZ_tab <= isZ_tab_stage4;
      END IF;
   END PROCESS;

   I11 : FPnormalize GENERIC MAP (SIG_width=>15) PORT MAP (SIG_in=>SIG_round_int, EXP_in=>EXP_round_int, SIG_out=>SIG_norm2_int, EXP_out=>Z_EXP_int);
   I10 : FPround GENERIC MAP (SIG_width=>15) PORT MAP (SIG_in=>SIG_norm, EXP_in=>EXP_norm, SIG_out=>SIG_round_int, EXP_out=>EXP_round_int);
END struct;
