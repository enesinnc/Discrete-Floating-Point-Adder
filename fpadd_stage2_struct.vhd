-- FPadd_stage2.vhd --
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY FPadd_stage2 IS
   PORT( 
      ADD_SUB_out      : IN  std_logic;
      A_EXP            : IN  std_logic_vector (7 DOWNTO 0);
      A_SIGN           : IN  std_logic;
      A_in             : IN  std_logic_vector (15 DOWNTO 0);
      A_isINF          : IN  std_logic;
      A_isNaN          : IN  std_logic;
      A_isZ            : IN  std_logic;
      B_EXP            : IN  std_logic_vector (7 DOWNTO 0);
      B_XSIGN          : IN  std_logic;
      B_in             : IN  std_logic_vector (15 DOWNTO 0);
      B_isINF          : IN  std_logic;
      B_isNaN          : IN  std_logic;
      B_isZ            : IN  std_logic;
      EXP_diff         : IN  std_logic_vector (8 DOWNTO 0);
      cin_sub          : IN  std_logic;
      clk              : IN  std_logic;
      A_SIGN_stage2    : OUT std_logic;
      A_align          : OUT std_logic_vector (15 DOWNTO 0);
      B_XSIGN_stage2   : OUT std_logic;
      B_align          : OUT std_logic_vector (15 DOWNTO 0);
      EXP_base_stage2  : OUT std_logic_vector (7 DOWNTO 0);
      cin              : OUT std_logic;
      invert_A         : OUT std_logic;
      invert_B         : OUT std_logic;
      isINF_tab_stage2 : OUT std_logic;
      isNaN_stage2     : OUT std_logic;
      isZ_tab_stage2   : OUT std_logic
   );
END FPadd_stage2 ;

ARCHITECTURE struct OF FPadd_stage2 IS
   SIGNAL A_CS          : std_logic_vector(15 DOWNTO 0);
   SIGNAL A_align_int   : std_logic_vector(15 DOWNTO 0);
   SIGNAL B_CS          : std_logic_vector(15 DOWNTO 0);
   SIGNAL B_align_int   : std_logic_vector(15 DOWNTO 0);
   SIGNAL EXP_base_int  : std_logic_vector(7 DOWNTO 0);
   SIGNAL cin_int       : std_logic;
   SIGNAL diff          : std_logic_vector(8 DOWNTO 0);
   SIGNAL invert_A_int  : std_logic;
   SIGNAL invert_B_int  : std_logic;
   SIGNAL isINF_tab_int : std_logic;
   SIGNAL isNaN_int     : std_logic;
   SIGNAL isZ_tab_int   : std_logic;
   SIGNAL swap_AB       : std_logic;
   SIGNAL mw_I2din0     : std_logic_vector(7 DOWNTO 0);
   SIGNAL mw_I2din1     : std_logic_vector(7 DOWNTO 0);

   COMPONENT FPalign
   PORT (
      A_in  : IN  std_logic_vector (15 DOWNTO 0);
      B_in  : IN  std_logic_vector (15 DOWNTO 0);
      cin   : IN  std_logic ;
      diff  : IN  std_logic_vector (8 DOWNTO 0);
      A_out : OUT std_logic_vector (15 DOWNTO 0);
      B_out : OUT std_logic_vector (15 DOWNTO 0)
   );
   END COMPONENT;

   COMPONENT FPswap
   GENERIC ( width : integer := 16 );
   PORT (
      A_in    : IN  std_logic_vector (width-1 DOWNTO 0);
      B_in    : IN  std_logic_vector (width-1 DOWNTO 0);
      swap_AB : IN  std_logic ;
      A_out   : OUT std_logic_vector (width-1 DOWNTO 0);
      B_out   : OUT std_logic_vector (width-1 DOWNTO 0)
   );
   END COMPONENT;

BEGIN
   PROCESS(clk)
   BEGIN
      IF RISING_EDGE(clk) THEN
         cin <= cin_int; invert_A <= invert_A_int; invert_B <= invert_B_int;
         EXP_base_stage2 <= EXP_base_int; A_align <= A_align_int; B_align <= B_align_int;
         A_SIGN_stage2 <= A_SIGN; B_XSIGN_stage2 <= B_XSIGN;
         isINF_tab_stage2 <= isINF_tab_int; isNaN_stage2 <= isNaN_int; isZ_tab_stage2 <= isZ_tab_int;
      END IF;
   END PROCESS;

   swap_AB <= EXP_diff(8);
   diff <= EXP_diff(8 DOWNTO 0);

   InvertLogic_truth_process: PROCESS(A_SIGN, B_XSIGN, swap_AB)
   BEGIN
      IF (A_SIGN = '0') AND (B_XSIGN = '0') THEN invert_A_int <= '0'; invert_B_int <= '0';
      ELSIF (A_SIGN = '1') AND (B_XSIGN = '1') THEN invert_A_int <= '0'; invert_B_int <= '0';
      ELSIF (A_SIGN = '0') AND (B_XSIGN = '1') AND (swap_AB = '0') THEN invert_A_int <= '0'; invert_B_int <= '1';
      ELSIF (A_SIGN = '0') AND (B_XSIGN = '1') AND (swap_AB = '1') THEN invert_A_int <= '1'; invert_B_int <= '0';
      ELSIF (A_SIGN = '1') AND (B_XSIGN = '0') AND (swap_AB = '0') THEN invert_A_int <= '1'; invert_B_int <= '0';
      ELSIF (A_SIGN = '1') AND (B_XSIGN = '0') AND (swap_AB = '1') THEN invert_A_int <= '0'; invert_B_int <= '1';
      ELSE invert_A_int <= '0'; invert_B_int <= '0'; END IF;
   END PROCESS InvertLogic_truth_process;

   exceptions_truth_process: PROCESS(ADD_SUB_out, A_isINF, A_isNaN, A_isZ, B_isINF, B_isNaN, B_isZ)
   BEGIN
      IF (A_isNaN = '1') THEN isINF_tab_int <= '0'; isNaN_int <= '1'; isZ_tab_int <= '0';
      ELSIF (B_isNaN = '1') THEN isINF_tab_int <= '0'; isNaN_int <= '1'; isZ_tab_int <= '0';
      ELSIF (ADD_SUB_out = '1') AND (A_isINF = '1') AND (B_isINF = '1') THEN isINF_tab_int <= '1'; isNaN_int <= '0'; isZ_tab_int <= '0';
      ELSIF (ADD_SUB_out = '0') AND (A_isINF = '1') AND (B_isINF = '1') THEN isINF_tab_int <= '0'; isNaN_int <= '1'; isZ_tab_int <= '0';
      ELSIF (A_isINF = '1') THEN isINF_tab_int <= '1'; isNaN_int <= '0'; isZ_tab_int <= '0';
      ELSIF (B_isINF = '1') THEN isINF_tab_int <= '1'; isNaN_int <= '0'; isZ_tab_int <= '0';
      ELSIF (A_isZ = '1') AND (B_isZ = '1') THEN isINF_tab_int <= '0'; isNaN_int <= '0'; isZ_tab_int <= '1';
      ELSE isINF_tab_int <= '0'; isNaN_int <= '0'; isZ_tab_int <= '0'; END IF;
   END PROCESS exceptions_truth_process;

   I2combo: PROCESS(mw_I2din0, mw_I2din1, swap_AB)
   VARIABLE dtemp : std_logic_vector(7 DOWNTO 0);
   BEGIN
      CASE swap_AB IS
      WHEN '0'|'L' => dtemp := mw_I2din0;
      WHEN '1'|'H' => dtemp := mw_I2din1;
      WHEN OTHERS => dtemp := (OTHERS => 'X');
      END CASE;
      EXP_base_int <= dtemp;
   END PROCESS I2combo;
   
   mw_I2din0 <= A_EXP; mw_I2din1 <= B_EXP;
   cin_int <= invert_B_int OR invert_A_int;

   I4 : FPalign PORT MAP (A_in=>A_CS, B_in=>B_CS, cin=>cin_sub, diff=>diff, A_out=>A_align_int, B_out=>B_align_int);
   I3 : FPswap GENERIC MAP (width=>16) PORT MAP (A_in=>A_in, B_in=>B_in, swap_AB=>swap_AB, A_out=>A_CS, B_out=>B_CS);
END struct;