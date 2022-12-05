library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Score is
port(
clk,rst: in  std_logic;
Pin,Nin: in  std_Logic;
outpt:   out std_logic_vector(11 downto 0):="000000000000");
end;

architecture one of Score is

component Score2Segment
port(
inpt:  in  std_logic_vector(7  downto 0);
outpt: out std_logic_vector(11 downto 0));
end component;

signal s: std_logic_vector(7 downto 0):="00000000";
begin
process(rst,clk)
begin
if (rst = '0') then s <= (others => '0');
elsif (clk 'event and clk = '0') then
	if (Pin = '1') then
		s <= s + 5;
	end if;
	if (Nin = '1') then
		s <= s - 3;
	end if;
end if;
end process;
U: Score2Segment port map (s,outpt);
end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Score2Segment is
port(
inpt:  in  std_logic_vector(7  downto 0);
outpt: out std_logic_vector(11 downto 0));
end;

architecture one of Score2Segment is
signal s: std_logic_vector(11 downto 0);
begin

s <= "0000"&inpt;

outpt <= s+90 when inpt > 149 else
			s+84 when inpt > 139 else
			s+78 when inpt > 129 else
			s+72 when inpt > 119 else
			s+66 when inpt > 109 else
			s+60 when inpt > 99  else
			s+54 when inpt > 89  else
			s+48 when inpt > 79  else
			s+42 when inpt > 69  else
			s+36 when inpt > 59  else
			s+30 when inpt > 49  else
			s+24 when inpt > 39  else
			s+18 when inpt > 29  else
			s+12 when inpt > 19  else
			s+6  when inpt > 9   else
			s;

end;