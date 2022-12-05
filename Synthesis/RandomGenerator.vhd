library ieee;
use ieee.std_logic_1164.all;

entity RandomGenerator is
port(
clk,rst: in  std_logic;
outpt: 	out std_logic_vector(21 downto 0));
end;

architecture one of RandomGenerator is

-- Signals --
signal rand: std_Logic_vector(21 downto 0);
signal x: 	 std_Logic;
-- Signals --

begin
process(rst,clk)
begin
if (rst = '0') then
	rand <= "0010010001110110100111";
elsif (clk 'event and clk = '1') then
	rand <= rand(20 downto 0) & x;
end if;
end process;
x <= rand(0)  xor rand(1)  xor rand(2)  xor rand(3)  xor rand(4)  xor
	  rand(5)  xor rand(6)  xor rand(7)  xor rand(8)  xor rand(9)  xor
	  rand(10) xor rand(11) xor rand(12) xor rand(13) xor rand(14) xor
	  rand(15) xor rand(16) xor rand(17) xor rand(18) xor rand(19) xor
	  rand(20) xor rand(21);
outpt <= rand;
end;