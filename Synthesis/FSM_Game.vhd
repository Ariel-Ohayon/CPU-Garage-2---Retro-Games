library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FSM_Game is
port(
rst:					in  std_logic;
clk,hit1,hit2:		in  std_logic;
clk_50: 				in  std_logic;
RedX1,RedY1:		out std_logic_vector(31 downto 0);
BlueX1,BlueY1:		out std_logic_vector(31 downto 0);
num,num2:			out std_logic_vector(3 downto 0); -- seg1,seg2
drwBlue:				out std_logic;
drwRed:				out std_logic;
drwGO:				out std_logic;
HEX0,HEX1:			out std_logic_vector(3 downto 0)); --seg5,seg6
end;

architecture one of FSM_Game is

type state is (s0,s1,s2,s3,s4,s5,s6,s7,s8,s9l,s9,s10l,s10,s11l,s11,EndG);

-- Components --

component Timer
port(
rst,clk: in  std_logic;
En:		in  std_logic;
Q: 		out std_logic_vector(5 downto 0);
over:		out std_logic);
end component;

component Timer2
port(
rst,clk_50: in std_logic;
dir: in std_logic;
Xi: in  std_logic_vector(31 downto 0);
Xo: buffer std_logic_vector(31 downto 0);
endVal: in std_logic_vector(31 downto 0);
endShift: out std_logic:='0');
end component;

component Timer2Segment
port(
inpt:  in  std_logic_vector(5 downto 0);
outpt: out std_logic_vector(7 downto 0));
end component;

-- Components --

-- Signals --
-- Level 1 in the game
signal psR,psB:     state;
signal nsR,nsB:   state;

 -- Level 2 in the game
signal lvl:			  std_logic:='0';

signal Q:			  std_logic_vector(5 downto 0);
signal SEG:			  std_logic_vector(7 downto 0);
signal over:		  std_logic;
signal En:			  std_logic := '1';
signal rstTimer:	  std_logic;
signal sigEnd:		  std_logic := '0';
signal Load:		  std_logic:='0';
signal Load2:		  std_logic:='0';

signal dir,endShift: std_logic;
signal Xi,endval: std_logic_vector(31 downto 0);
signal Xo: std_logic_vector(31 downto 0);

signal dir2,endShift2: std_logic;
signal Xi2,endval2: std_logic_vector(31 downto 0);
signal Xo2: std_logic_vector(31 downto 0);
-- Signals --

begin

T:   Timer 			 port map (rst and rstTimer,clk_50,En,Q,over);
T2:  Timer2			 port map (Load,clk_50,dir,Xi,Xo,endval,endShift);
T3:  Timer2			 port map (Load2,clk_50,dir2,Xi2,Xo2,endval2,endShift2);
T2S: Timer2Segment port map (Q,SEG);
HEX1 <= SEG(7 downto 4);
HEX0 <= SEG(3 downto 0);

process(rst,clk_50)
begin
if (rst = '0') then
	psR <= s0;
	psB <= s0;
elsif (clk_50 'event and clk_50 = '1') then
	if (psR = EndG) then psB <= EndG; else
		psB <= nsB;
		psR <= nsR;
	end if;
end if;
end process;

-- 800[DEC] = 01100100000[bin] = x"320" (line1)
-- 730[dec] = 01011011010[bin] = x"2DA" (line2)
-- 650[dec] = 01010001010[bin] = x"28A" (line3)
-- 500[dec] = 00111110100[bin] = x"1F4" (line4)
-- 400[dec] = 00110010000[bin] = x"190" (line5)
-- 220[dec] = 00011011100[bin] = x"DC"  (line6)


process(psR)

variable l1: std_logic_vector(31 downto 0) := x"0000027C"; -- (60  - 1220)
variable l2: std_logic_vector(31 downto 0) := x"00000236"; -- (60  - 1220)
variable l3: std_logic_vector(31 downto 0) := x"000001E6"; -- (60  - 1220)
variable l4: std_logic_vector(31 downto 0) := x"00000150"; -- (100 - 1180)
variable l5: std_logic_vector(31 downto 0) := x"000000EC"; -- (100 - 1180)
variable l6: std_logic_vector(31 downto 0) := x"00000038"; -- (200 - 1080)

begin
case psR is
when s0   =>if (hit1 = '1') then nsR <= s1;   else nsR <= s0; end if; RedX1 <= x"0000003C"; RedY1 <= l1; num <= "0000"; drwRed<='1'; rstTimer <= '1'; drwGO <= '0';
when s1   =>if (hit1 = '1') then nsR <= s2;   else nsR <= s1; end if; RedX1 <= x"0000026C"; RedY1 <= l2; num <= "0001"; drwRed<='1'; rstTimer <= '1'; drwGO <= '0';
when s2   =>if (hit1 = '1') then nsR <= s3;   else nsR <= s2; end if; RedX1 <= x"000000D1"; RedY1 <= l3; num <= "0010"; drwRed<='1'; rstTimer <= '1'; drwGO <= '0';
when s3   =>if (hit1 = '1') then nsR <= s4;   else nsR <= s3; end if; RedX1 <= x"000002DE"; RedY1 <= l3; num <= "0011"; drwRed<='1'; rstTimer <= '1'; drwGO <= '0';
when s4   =>if (hit1 = '1') then nsR <= s5;   else nsR <= s4; end if; RedX1 <= x"0000033F"; RedY1 <= l4; num <= "0100"; drwRed<='1'; rstTimer <= '1'; drwGO <= '0';
when s5   =>if (hit1 = '1') then nsR <= s6;   else nsR <= s5; end if; RedX1 <= x"000001A9"; RedY1 <= l3; num <= "0101"; drwRed<='1'; rstTimer <= '1'; drwGO <= '0';
when s6   =>if (hit1 = '1') then nsR <= s7;   else nsR <= s6; end if; RedX1 <= x"00000154"; RedY1 <= l6; num <= "0110"; drwRed<='1'; rstTimer <= '1'; drwGO <= '0';
when s7   =>if (hit1 = '1') then nsR <= s8;   else nsR <= s7; end if; RedX1 <= x"00000387"; RedY1 <= l5; num <= "0111"; drwRed<='1'; rstTimer <= '1'; drwGO <= '0';
when s8   =>if (hit1 = '1') then nsR <= s9l;  else nsR <= s8; end if; RedX1 <= x"00000178"; RedY1 <= l1; num <= "1000"; drwRed<='1'; rstTimer <= '1'; drwGO <= '0';
when s9l  => Load <= '1'; dir <= '1'; endVal <= x"0000033F"; Xi <= x"0000003C"; nsR <= s9; drwRed<='0';
when s9   =>if (hit1 = '1' or endShift = '1') then nsR <= s10l; else nsR <= s9; end if; Load <= '0'; drwRed<='1'; num <= "1001"; RedX1 <= Xo; RedY1 <= l1;
when s10l => Load <= '1'; dir <= '0'; endval <= x"00000178"; Xi <= x"000002DE"; nsR <= s10; drwRed <= '0';
when s10  =>if (hit1 = '1' or endshift = '1') then nsR <= s11l; else nsR <= s10; end if; Load <= '0'; drwRed<='1'; num <= "1010"; RedX1 <= Xo; RedY1 <= l4;
when s11l => Load <= '1'; dir <= '1'; endval <= x"000001A9"; Xi <= x"00000086"; nsR <= s11; drwRed<='0';
when s11  =>if (hit1 = '1' or endshift = '1') then nsR <= EndG; else nsR <= s11; end if; Load <= '0'; drwRed<='1'; num <= "1011"; RedX1 <= Xo; RedY1 <= l2;
when EndG => lvl<='1'; sigEnd<='1'; drwRed<='0'; num <= "1111"; rstTimer <= '0'; drwGO <= '1';
end case;
end process;

process(psB)
variable l1: std_logic_vector(31 downto 0) := x"0000027C"; -- (60  - 1220)
variable l2: std_logic_vector(31 downto 0) := x"00000236"; -- (60  - 1220)
variable l3: std_logic_vector(31 downto 0) := x"000001E6"; -- (60  - 1220)
variable l4: std_logic_vector(31 downto 0) := x"00000150"; -- (100 - 1180)
variable l5: std_logic_vector(31 downto 0) := x"000000EC"; -- (100 - 1180)
variable l6: std_logic_vector(31 downto 0) := x"00000038"; -- (200 - 1080)
begin

case psB is
when s0 => 
				if (Q = "110111") then
					nsB <= s1;
				else
					nsB <= s0;
				end if;
				BlueX1 <= (others => '0');
				BlueY1 <= (others => '0');
				drwBlue <= '0';
				num2 <= "0000";
when s1 =>
				if (Q = "110101" or hit2 = '1') then
					nsB <= s2;
				else
					nsB <= s1;
				end if;
				BlueX1 <= x"0000032D";
				BlueY1 <= l2;
				drwBlue <= '1';
				num2 <= "0001";
when s2 =>
				if (Q = "110001" or hit2 = '1') then
					nsB <= s3;
				else
					nsB <= s2;
				end if;
				BlueX1 <= x"0000015B";
				BlueY1 <= l3;
				drwBlue <= '1';
				num2 <= "0010";
when s3 =>
				if (Q = "101011") then
					nsB <= s4;
				else
					nsB <= s3;
				end if;
				BlueX1 <= (others => '0');
				BlueY1 <= (others => '0');
				drwBlue <= '0';
				num2 <= "0011";
when s4 =>
				if (Q = "100011" or hit2 = '1') then 	--		Q = 25[DEC]
					nsB <= s5;
				else
					nsB <= s4;
				end if;
				BlueX1 <= x"000002A9";
				BlueY1 <= l4;
				drwBlue <= '1';
				num2 <= "0100";
when s5 =>
				if (Q = "010110" or hit2 = '1') then
					nsB <= s6;
				else
					nsB <= s5;
				end if;
				BlueX1 <= x"00000113";
				BlueY1 <= l3;
				drwBlue <= '1';
				num2 <= "0101";
when s6 =>
				nsB   <= s7;
				Load2 <= '1';
				dir2  <= '0';
				endval2 <= x"0000015D";
				Xi2      <= x"000002E6";
				drwBlue <= '0';
when s7 => 
				if (hit2 = '1' or endshift2 = '1') then
					nsB <= s8;
				else
					nsB <= s7;
				end if;
				Load2 <= '0';
				drwBlue <= '1';
				BlueX1 <= Xo2;
				BlueY1 <= l3;
when others =>
				drwBlue <= '0';
end case;
end process;

end;


-- / Timer Module \ --
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Timer is
port(
rst,clk: in		 std_logic;
En:		in 	 std_logic;
Q: 		buffer std_logic_vector(5 downto 0);
over:		out	 std_logic);
end;

architecture one of Timer is

component Generator
generic(N:  integer:= 50000000;
		  DC: integer:= 25000000);
port(
clkin: in std_logic;
clkout: buffer std_logic:='1');
end component;

signal clko: std_logic;

begin
Gen: Generator generic map (50000000,50000000/2) port map (clk,clko);
process(rst,clk)
begin
if (rst = '0') then
	Q <= "111100";
	over <= '0';
elsif (clko 'event and clko = '1') then
	if (En = '1') then
		if (Q = "000000") then
			Q <= "111100";
			over <= '1';
		else
			over <= '0';
			Q <= Q - 1;
		end if;
	end if;
end if;
end process;
end;

--/ Timer2 \--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Timer2 is
port(
rst,clk_50: in std_logic;
dir: in std_logic;
Xi: in  std_logic_vector(31 downto 0);
Xo: buffer std_logic_vector(31 downto 0);
endVal: in std_logic_vector(31 downto 0);
endShift: out std_logic:='0');
end;

architecture one of Timer2 is

component Generator
generic(N:  integer:= 50000000;
		  DC: integer:= 25000000);
port(
clkin: in std_logic;
clkout: buffer std_logic:='1');
end component;
signal clk: std_logic;
begin
U: Generator generic map (312500,312500/2) port map (clk_50,clk);
process(rst,clk)
begin
if (rst = '1') then
	Xo <= Xi;
	endShift <= '0';
elsif (clk 'event and clk = '1') then
	if (dir = '1') then
		if (Xo < endVal) then
			Xo <= Xo+1;
		else
			endShift <= '1';
		end if;
	else
		if (Xo > endVal) then
			Xo <= Xo-1;
		else
			endShift <= '1';
		end if;
	end if;
end if;
end process;
end;

--/ Timer2Segment \--
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Timer2Segment is
port(
inpt:  in  std_logic_vector(5 downto 0);
outpt: out std_logic_vector(7 downto 0));
end;

architecture one of Timer2Segment is
signal s: std_logic_vector(7 downto 0);
begin

s <= "00"&inpt;

outpt <= s+36 when inpt > 59 else
			s+30 when inpt > 49 else
			s+24 when inpt > 39 else
			s+18 when inpt > 29 else
			s+12 when inpt > 19 else
			s+6  when inpt > 9  else
			s;

end;