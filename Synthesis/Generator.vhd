library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Generator is
generic(N:  integer:= 50000000;
		  DC: integer:= 25000000);
port(
clkin: in std_logic;
clkout: buffer std_logic:='1');
end;

architecture one of Generator is
signal count: integer range 0 to N := 0;
begin
process(clkin)
begin
if (clkin 'event and clkin = '1') then 
	if (count = N) then
		count <= 0;
		clkout <= '1';
	elsif (count = DC) then
		count <= count + 1;
		clkout <= '0';
	else
		count <= count + 1;
	end if;
end if;
end process;
end;