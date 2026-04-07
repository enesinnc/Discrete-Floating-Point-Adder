LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY FPlzc IS
   PORT( 
      word  : IN     std_logic_vector (13 DOWNTO 0); -- 26'dan 13'e düþürüldü
      zero  : OUT    std_logic;
      count : OUT    std_logic_vector (4 DOWNTO 0)
   );
END FPlzc ;

ARCHITECTURE FPlzc OF FPlzc IS
BEGIN
   PROCESS(word)
   BEGIN
      zero <= '0';
      IF (word(13 DOWNTO 0)="00000000000000") THEN 
         count <= "01110"; -- 14
         zero <= '1';
      ELSIF (word(13 DOWNTO 1)="0000000000000") THEN count <= "01101"; -- 13
      ELSIF (word(13 DOWNTO 2)="000000000000") THEN count <= "01100"; -- 12
      ELSIF (word(13 DOWNTO 3)="00000000000") THEN count <= "01011"; -- 11
      ELSIF (word(13 DOWNTO 4)="0000000000") THEN count <= "01010"; -- 10
      ELSIF (word(13 DOWNTO 5)="000000000") THEN count <= "01001"; -- 9
      ELSIF (word(13 DOWNTO 6)="00000000") THEN count <= "01000"; -- 8
      ELSIF (word(13 DOWNTO 7)="0000000") THEN count <= "00111"; -- 7
      ELSIF (word(13 DOWNTO 8)="000000") THEN count <= "00110"; -- 6
      ELSIF (word(13 DOWNTO 9)="00000") THEN count <= "00101"; -- 5
      ELSIF (word(13 DOWNTO 10)="0000") THEN count <= "00100"; -- 4
      ELSIF (word(13 DOWNTO 11)="000") THEN count <= "00011"; -- 3
      ELSIF (word(13 DOWNTO 12)="00") THEN count <= "00010"; -- 2
      ELSIF (word(13)='0') THEN count <= "00001"; -- 1
      ELSE
         count <= "00000"; -- 0
      END IF;
   END PROCESS;
END FPlzc;