LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY FPinvert IS
   GENERIC( 
      width : integer := 16 -- 29'dan 16'ya düþürüldü
   );
   PORT( 
      A_in     : IN     std_logic_vector (width-1 DOWNTO 0);
      B_in     : IN     std_logic_vector (width-1 DOWNTO 0);
      invert_A : IN     std_logic;
      invert_B : IN     std_logic;
      A_out    : OUT    std_logic_vector (width-1 DOWNTO 0);
      B_out    : OUT    std_logic_vector (width-1 DOWNTO 0)
   );
END FPinvert ;

ARCHITECTURE FPinvert OF FPinvert IS
BEGIN
   A_out <= (NOT A_in) WHEN (invert_A='1') ELSE A_in;
   B_out <= (NOT B_in) WHEN (invert_B='1') ELSE B_in;
END FPinvert;