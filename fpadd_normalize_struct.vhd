-- FPadd_normalize.vhd --
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

ENTITY FPadd_normalize IS
   PORT( 
      EXP_in  : IN  std_logic_vector (7 DOWNTO 0);
      SIG_in  : IN  std_logic_vector (14 DOWNTO 0);
      EXP_out : OUT std_logic_vector (7 DOWNTO 0);
      SIG_out : OUT std_logic_vector (14 DOWNTO 0);
      zero    : OUT std_logic
   );
END FPadd_normalize ;

ARCHITECTURE struct OF FPadd_normalize IS
   SIGNAL EXP_lshift : std_logic_vector(7 DOWNTO 0);
   SIGNAL EXP_rshift : std_logic_vector(7 DOWNTO 0);
   SIGNAL SIG_lshift : std_logic_vector(14 DOWNTO 0);
   SIGNAL SIG_rshift : std_logic_vector(14 DOWNTO 0);
   SIGNAL add_in     : std_logic_vector(7 DOWNTO 0);
   SIGNAL cin        : std_logic;
   SIGNAL count      : std_logic_vector(4 DOWNTO 0);
   SIGNAL isDN       : std_logic;
   SIGNAL shift_RL   : std_logic;
   SIGNAL word       : std_logic_vector(13 DOWNTO 0);
   SIGNAL zero_int   : std_logic;
   SIGNAL denormal   : std_logic;
   SIGNAL lshift_cnt : std_logic_vector(4 DOWNTO 0);

   COMPONENT FPlzc
   PORT (
      word  : IN  std_logic_vector (13 DOWNTO 0);
      zero  : OUT std_logic ;
      count : OUT std_logic_vector (4 DOWNTO 0)
   );
   END COMPONENT;

BEGIN
   SIG_rshift <= '0' & SIG_in(14 DOWNTO 2) & (SIG_in(1) AND SIG_in(0));
   add_in <= "000" & count;

   -- ====================================================
   -- DÜZELTÝLEN KISIM: Ýþaretli (signed) kýyaslama iptal edildi.
   -- Ýþaretsiz vektör büyüklüðü karþýlaþtýrmasý yapýlýyor.
   -- ====================================================
   PROCESS(count, EXP_in)
   BEGIN
      IF (("000" & count) > EXP_in) THEN 
         lshift_cnt <= EXP_in(4 downto 0) - 1; 
         denormal <= '1';
      ELSE 
         lshift_cnt <= count; 
         denormal <= '0'; 
      END IF;
   END PROCESS;

   PROCESS( isDN, shift_RL, EXP_lshift, EXP_rshift, EXP_in, SIG_lshift, SIG_rshift, SIG_in, denormal)
   BEGIN
   IF (isDN='1') THEN EXP_out <= X"00"; SIG_out <= SIG_in;
   ELSE
      IF (shift_RL='1') THEN
         IF (SIG_in(14)='1') THEN EXP_out <= EXP_rshift; SIG_out <= SIG_rshift;
         ELSE EXP_out <= EXP_in; SIG_out <= SIG_in; END IF;
      ELSE
         IF (denormal='1') THEN EXP_out <= (OTHERS => '0'); SIG_out <= SIG_lshift;
         ELSE EXP_out <= EXP_lshift; SIG_out <= SIG_lshift; END IF;
      END IF;
   END IF;
   END PROCESS;

   zero <= zero_int AND NOT SIG_in(14);
   word <= SIG_in(13 DOWNTO 0);

   PROCESS(SIG_in,EXP_in)
   BEGIN
      IF (SIG_in(14)='0' AND SIG_in(13)='0' AND (EXP_in=X"01")) THEN isDN <= '1'; shift_RL <= '0';
      ELSIF (SIG_in(14)='0' AND SIG_in(13)='0' AND (EXP_in/=X"00")) THEN isDN <= '0'; shift_RL <= '0';
      ELSE isDN <= '0'; shift_RL <= '1'; END IF;
   END PROCESS;

   cin <= '0';

   I4combo: PROCESS (EXP_in)
   VARIABLE t0 : std_logic_vector(8 DOWNTO 0);
   VARIABLE sum : signed(8 DOWNTO 0);
   VARIABLE din_l : std_logic_vector(7 DOWNTO 0);
   BEGIN
      din_l := EXP_in;
      t0 := din_l(7) & din_l;
      sum := (signed(t0) + '1');
      EXP_rshift <= conv_std_logic_vector(sum(7 DOWNTO 0),8);
   END PROCESS I4combo;

   I1combo : PROCESS (SIG_in, lshift_cnt)
   VARIABLE stemp : std_logic_vector (4 DOWNTO 0);
   VARIABLE dtemp : std_logic_vector (14 DOWNTO 0);
   VARIABLE temp : std_logic_vector (14 DOWNTO 0);
   BEGIN
      temp := (OTHERS=> 'X'); stemp := lshift_cnt; temp := SIG_in;
      FOR i IN 3 DOWNTO 0 LOOP
         IF (stemp(i) = '1' OR stemp(i) = 'H') THEN
            dtemp := (OTHERS => '0');
            dtemp(14 DOWNTO 2**i) := temp(14 - 2**i DOWNTO 0);
         ELSIF (stemp(i) = '0' OR stemp(i) = 'L') THEN dtemp := temp;
         ELSE dtemp := (OTHERS => 'X'); END IF;
         temp := dtemp;
      END LOOP;
      SIG_lshift <= dtemp;
   END PROCESS I1combo;

   I2combo: PROCESS (EXP_in, add_in, cin)
   VARIABLE mw_I2t0 : std_logic_vector(8 DOWNTO 0);
   VARIABLE mw_I2t1 : std_logic_vector(8 DOWNTO 0);
   VARIABLE diff : signed(8 DOWNTO 0);
   VARIABLE borrow : std_logic;
   BEGIN
      mw_I2t0 := EXP_in(7) & EXP_in; mw_I2t1 := add_in(7) & add_in; borrow := cin;
      diff := signed(mw_I2t0) - signed(mw_I2t1) - borrow;
      EXP_lshift <= conv_std_logic_vector(diff(7 DOWNTO 0),8);
   END PROCESS I2combo;

   I0 : FPlzc PORT MAP (word=>word, zero=>zero_int, count=>count);
END struct;