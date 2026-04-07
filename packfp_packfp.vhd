LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY PackFP IS
   PORT( 
      SIGN  : IN     std_logic;
      EXP   : IN     std_logic_vector (7 DOWNTO 0);
      SIG   : IN     std_logic_vector (9 DOWNTO 0); -- 22'den 9'a düþürüldü (10 bit)
      isNaN : IN     std_logic;
      isINF : IN     std_logic;
      isZ   : IN     std_logic;
      FP    : OUT    std_logic_vector (18 DOWNTO 0) -- 31'den 18'e düþürüldü (19 bit)
   );
END PackFP ;

ARCHITECTURE PackFP OF PackFP IS
BEGIN
   PROCESS(isNaN,isINF,isZ,SIGN,EXP,SIG)
   BEGIN
      IF (isNaN='1') THEN
         FP(18) <= SIGN;
         FP(17 DOWNTO 10) <= X"FF";
         FP(9 DOWNTO 0) <= "1000000000"; -- NaN için default deðer
      ELSIF (isINF='1') THEN
         FP(18) <= SIGN;
         FP(17 DOWNTO 10) <= X"FF";
         FP(9 DOWNTO 0) <= (OTHERS => '0');
      ELSIF (isZ='1') THEN
         FP(18) <= SIGN;
         FP(17 DOWNTO 10) <= X"00";
         FP(9 DOWNTO 0) <= (OTHERS => '0');
      ELSE	
         FP(18) <= SIGN;
         FP(17 DOWNTO 10) <= EXP;
         FP(9 DOWNTO 0) <= SIG;
      END IF;
   END PROCESS;
END PackFP;