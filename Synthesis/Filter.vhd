library ieee;
use ieee.std_logic_1164.all;

entity Filter is
port(
clk,rst: in  std_logic;
inpt:    in  std_logic;
outpt:   out std_logic);
end;

architecture one of Filter is
signal Q: std_logic_vector(2 downto 0);
begin
process(clk,rst)
begin
if (rst = '0') then
	Q 		<= (others => '0');
	outpt <= '0';
elsif (clk 'event and clk = '1') then
	Q(0) <= inpt;
	Q(1) <= Q(0);
	Q(2) <= Q(1);
	outpt <= Q(0) and Q(1) and (not Q(2));
end if;
end process;
end;