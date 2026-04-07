LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY FPnormalize IS
   GENERIC( 
      SIG_width : integer := 15 -- 28'den 15'e düþürüldü
   );
   PORT( 
      SIG_in  : IN     std_logic_vector (SIG_width-1 DOWNTO 0);
      EXP_in  : IN     std_logic_vector (7 DOWNTO 0);
      SIG_out : OUT    std_logic_vector (SIG_width-1 DOWNTO 0);
      EXP_out : OUT    std_logic_vector (7 DOWNTO 0)
   );
END FPnormalize ;

ARCHITECTURE FPnormalize OF FPnormalize IS
BEGIN
   PROCESS(SIG_in, EXP_in)
   BEGIN
      IF (SIG_in( SIG_width-1 )='1') THEN
         SIG_out <= '0' & SIG_in(SIG_width-1 DOWNTO 2) & (SIG_in(1) AND SIG_in(0));
         EXP_out <= EXP_in + 1;
      ELSE
         SIG_out <= SIG_in;
         EXP_out <= EXP_in;
      END IF;
   END PROCESS;
END FPnormalize;