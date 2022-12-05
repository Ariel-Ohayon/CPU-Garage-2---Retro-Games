library ieee;
use ieee.std_logic_1164.all;

entity Priority_Draw is
port(
rst,clk_108:	 	 in  std_logic;
Curdrw:				 in  std_logic;
l1drw1,l1drw2: 	 in  std_logic;					-- l1 (line1) - Vertical = 800[pix]
l2drw1,l2drw2: 	 in  std_logic;					-- l2 (line2) - vertical = 730[pix]
l3drw1,l3drw2: 	 in  std_logic;					-- l3 (line3) - vertical = 650[pix]
l4drw,l5drw,l6drw: in  std_logic;					-- l4 (line4) - vertical = 500[pix], l5 (line5) - vertical = 400[pix], l6 (line6) - vertical = 220[pix]
RGBCur:				 in  std_logic_vector(11 downto 0);
RGBl11,RGBl12: 	 in  std_logic_vector(11 downto 0);
RGBl21,RGBl22: 	 in  std_logic_vector(11 downto 0);
RGBl31,RGBl32: 	 in  std_logic_vector(11 downto 0);
RGBl4,RGBl5,RGBl6: in  std_logic_vector(11 downto 0);
bg:				 	 in  std_logic_vector(11 downto 0);
RGB:				 	 out std_logic_vector(11 downto 0));
end;

architecture one of Priority_Draw is
begin

process(clk_108,rst)
begin
if (rst = '0') then
	RGB <= (others => '0');
elsif (clk_108 'event and clk_108 = '1') then
	if (Curdrw = '1') then
		RGB <= RGBCur;
	elsif		(l1drw1 = '1') then
		RGB <= RGBl11;
	elsif (l1drw2 = '1') then
		RGB <= RGBl12;
	elsif (l2drw1 = '1') then
		RGB <= RGBl21;
	elsif (l2drw2 = '1') then
		RGB <= RGBl22;
	elsif (l3drw1 = '1') then
		RGB <= RGBl31;
	elsif (l3drw2 = '1') then
		RGB <= RGBl32;
	elsif (l4drw = '1') then
		RGB <= RGBl4;
	elsif (l5drw = '1') then
		RGB <= RGBl5;
	elsif (l6drw = '1') then
		RGB <= RGBl6;
	else
		RGB<=bg;
	end if;
end if;
end process;

end;