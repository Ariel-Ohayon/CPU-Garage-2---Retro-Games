-- DrawCursor Component

library ieee;
use ieee.std_Logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_Logic_arith.all;

entity DrawCursor is
port(
clk: in std_logic;
Xpxl,Ypxl: in std_logic_vector(31 downto 0);
topX,topY: in std_logic_vector(31 downto 0);
RGB: out std_logic_vector(11 downto 0);
drw: out std_logic;
pointDrw: out std_logic);
end;

architecture one of DrawCursor is
type mat is array (0 to 30, 0 to 25) of integer range 0 to 4095;
signal sRGB: mat :=
(
(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,0,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095),
(4095,4095,4095,4095,4095,4095,4095,4095,0,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095),
(4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095),
(4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095),
(4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095),
(4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,4095,4095,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,0,4095,4095,4095,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0),
(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0)
);

begin

process(clk)
variable Xoff,Yoff:std_logic_vector(31 downto 0);
begin
if (clk 'event and clk = '1') then
	Xoff := Xpxl - topX;
	Yoff := Ypxl - topY;
	if ( (Xpxl > topX) and (Xpxl < topX + 25) and (Ypxl > topY) and (Ypxl < topY + 30) ) then
		if ( sRGB( conv_integer(Yoff) , conv_integer(Xoff) ) = 0 ) then
			drw <= '0';
		else
			drw <= '1';
			RGB <= conv_std_logic_vector(sRGB(conv_integer(Yoff),conv_integer(Xoff)),12);
		end if;
	else
		drw <= '0';
	end if;
end if;
end process;
end;


-- Move Cursor Unit
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity MoveCursor is
port(
rst,clk_108: in std_logic;
u,d,r,l: 	 in std_logic;
X,Y: out std_logic_vector(31 downto 0));
end;

architecture one of MoveCursor is

component Generator
Generic (N:  integer:= 50000000;
		   DC: integer:= 25000000);

port(
clkin: in std_logic;
clkout: buffer std_logic:='1');
end component;

signal sX:  std_logic_vector(31 downto 0) := x"00000280";
signal sY:  std_logic_vector(31 downto 0) := x"00000200";
signal clk: std_logic;
begin
U1: Generator Generic map (100000,100000/2) port map (clk_108,clk);
process(rst,clk)
begin
	if (rst = '0') then
		sX <= x"00000280";
		sY <= x"00000200";
	elsif (clk 'event and clk = '1') then
		if (sY < 994 and sY > 0) then
			if (u = '0') then
				sY <= sY + 1;
			elsif (d = '0') then
				sY <= sY - 1;
			end if;
		end if;
		if (sX < 1255 and sX > 0) then
			if (r = '0') then
				sX <= sX + 1;
			elsif (l = '0') then
				sX <= sX - 1;
			end if;
		end if;
		if (sX = 0)    then sX <= sX+1; end if;
		if (sY = 0)    then sY <= sY+1; end if;
		if (sX = 1255) then sX <= sX-1; end if;
		if (sY = 994)  then sY <= sY-1; end if;
	end if;
end process;
X <= sX;
Y <= sY;
end;

-- Cursor Unit

library ieee;
use ieee.std_logic_1164.all;

entity CursorUnit is
port(
rst,clk_108,u,d,r,l: in  std_logic;
Xpxl,Ypxl: 		 	   in  std_logic_vector(31 downto 0);
RGB:		  		 	   out std_logic_vector(11 downto 0);
drw:					   out std_logic;
pointDrw:				out std_logic);
end;

architecture one of CursorUnit is

-- Components --
component DrawCursor
port(
clk: in std_logic;
Xpxl,Ypxl: in std_logic_vector(31 downto 0);
topX,topY: in std_logic_vector(31 downto 0);
RGB: out std_logic_vector(11 downto 0);
drw: out std_logic;
pointDrw: out std_logic);
end component;

component MoveCursor
port(
rst,clk_108: in std_logic;
u,d,r,l: 	 in std_logic;
X,Y: out std_logic_vector(31 downto 0));
end component;
-- Components --

signal X,Y: std_logic_vector(31 downto 0);

begin
U1: DrawCursor port map (clk_108,Xpxl,Ypxl,X,Y,RGB,drw,pointDrw);
U2: MoveCursor port map (rst,clk_108,u,d,r,l,X,Y);
end;