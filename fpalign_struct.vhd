-- FPalign.vhd --
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY FPalign IS
   PORT( 
      A_in  : IN  std_logic_vector (15 DOWNTO 0);
      B_in  : IN  std_logic_vector (15 DOWNTO 0);
      cin   : IN  std_logic;
      diff  : IN  std_logic_vector (8 DOWNTO 0);
      A_out : OUT std_logic_vector (15 DOWNTO 0);
      B_out : OUT std_logic_vector (15 DOWNTO 0)
   );
END FPalign ;

ARCHITECTURE struct OF FPalign IS
   SIGNAL B_shift  : std_logic_vector(15 DOWNTO 0);
   SIGNAL diff_int : std_logic_vector(8 DOWNTO 0);
   SIGNAL shift_B  : std_logic_vector(3 DOWNTO 0);
BEGIN
   PROCESS(diff_int, B_shift)
   BEGIN
      IF (diff_int(8)='1') THEN
         IF (((NOT diff_int) + 1) > 15) THEN B_out <= (OTHERS => '0');
         ELSE B_out <= B_shift; END IF;
      ELSE      
          IF (diff_int > 15) THEN B_out <= (OTHERS => '0');
          ELSE B_out <= B_shift; END IF;
      END IF;
   END PROCESS;

   PROCESS(diff_int)
   BEGIN
      IF (diff_int(8)='1') THEN shift_B <= (NOT diff_int(3 DOWNTO 0)) + 1;
      ELSE shift_B <= diff_int(3 DOWNTO 0) ; END IF;
   END PROCESS;

   PROCESS(cin,diff)
   BEGIN
      IF ((cin='1') AND (diff(8)='1')) THEN diff_int <= diff + 2;
      ELSE diff_int <= diff; END IF;
   END PROCESS;

   A_out <= A_in;

   I1combo : PROCESS (B_in, shift_B)
   VARIABLE stemp : std_logic_vector (3 DOWNTO 0);
   VARIABLE dtemp : std_logic_vector (15 DOWNTO 0);
   VARIABLE temp : std_logic_vector (15 DOWNTO 0);
   BEGIN
      temp := (OTHERS=> 'X');
      stemp := shift_B;
      temp := B_in;
      FOR i IN 3 DOWNTO 0 LOOP
         IF (stemp(i) = '1' OR stemp(i) = 'H') THEN
            dtemp := (OTHERS => '0');
            dtemp(15 - 2**i DOWNTO 0) := temp(15 DOWNTO 2**i);
         ELSIF (stemp(i) = '0' OR stemp(i) = 'L') THEN
            dtemp := temp;
         ELSE
            dtemp := (OTHERS => 'X');
         END IF;
         temp := dtemp;
      END LOOP;
      B_shift <= dtemp;
   END PROCESS I1combo;
END struct;

