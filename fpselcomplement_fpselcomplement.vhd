LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY FPselComplement IS
   GENERIC( 
      SIG_width : integer := 15 -- 28'den 15'e düþürüldü
   );
   PORT( 
      SIG_in  : IN     std_logic_vector (SIG_width DOWNTO 0);
      EXP_in  : IN     std_logic_vector (7 DOWNTO 0);
      SIG_out : OUT    std_logic_vector (SIG_width-1 DOWNTO 0);
      EXP_out : OUT    std_logic_vector (7 DOWNTO 0)
   );
END FPselComplement ;

ARCHITECTURE FPselComplement OF FPselComplement IS
BEGIN
   EXP_out <= EXP_in;
   PROCESS(SIG_in)
   BEGIN
      IF (SIG_in(SIG_width) = '1') THEN
         SIG_out <= (NOT SIG_in(SIG_width-1 DOWNTO 0) + 1);
      ELSE
         SIG_out <= SIG_in(SIG_width-1 DOWNTO 0);
      END IF;
   END PROCESS;
END FPselComplement;