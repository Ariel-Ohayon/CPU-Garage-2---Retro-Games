library ieee;
use ieee.std_logic_1164.all;

entity Project is
port(
hitSW:					in  std_logic;
u,d,ri,l: 				in  std_logic;
rst,clk_50: 			in  std_logic;
R,G,B: 					out std_logic_vector(3 downto 0);
H_Sync,V_Sync:			out std_logic;
--samp:						out std_logic;
HEX1,HEX2,HEX3,HEX4,HEX5,HEX6:	out std_logic_vector(6 downto 0));
end;

architecture one of Project is

-- Components --
component VGA_Controller
port(
inR,inG,inB:    in  std_logic_vector(3  downto 0);
rst,clk_108:    in std_logic;
outR,outG,outB: out std_logic_vector(3  downto 0);
X,Y:				 out std_logic_vector(31 downto 0);
H_Sync,V_Sync:  out std_logic);
end component;

component PLL
	PORT
	(
		areset		: IN  STD_LOGIC  := '0';
		inclk0		: IN  STD_LOGIC  := '0';
		c0				: OUT STD_LOGIC);
END component;

component Priority_Draw
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
end component;

component Background
port(
clk: in std_logic;
Xpxl,Ypxl: in std_logic_vector(31 downto 0);
RGB: out std_logic_vector(11 downto 0));
end component;

component CursorUnit
port(
rst,clk_108,u,d,r,l: in  std_logic;
Xpxl,Ypxl: 		 	   in  std_logic_vector(31 downto 0);
RGB:		  		 	   out std_logic_vector(11 downto 0);
drw:					   out std_logic;
pointDrw:				out std_logic);
end component;

component TargetRed
port(
clk_108:   in  std_logic;
topX,topY: in  std_logic_vector(31 downto 0);
Xpxl,Ypxl: in  std_logic_vector(31 downto 0);
RGB:		  out std_logic_vector(11 downto 0);
drw:		  out std_logic);
end component;

component FSM_Game
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
end component;

component RandomGenerator
port(
clk,rst: in  std_logic;
outpt: 	out std_logic_vector(21 downto 0));
end component;

component Segment_Decoder
port(
inpt: in  std_Logic_vector(3 downto 0);
HEX:  out std_logic_vector(6 downto 0));
end component;

component Filter
port(
clk,rst: in  std_logic;
inpt:    in  std_logic;
outpt:   out std_logic);
end component;

component TargetBlue
port(
clk_108:   in  std_logic;
topX,topY: in  std_logic_vector(31 downto 0);
Xpxl,Ypxl: in  std_logic_vector(31 downto 0);
RGB:		  out std_logic_vector(11 downto 0);
drw:		  out std_logic);
end component;

component GAMEOVER
port(
clk: in std_logic;
Xpxl,Ypxl: in std_logic_vector(31 downto 0);
topX,topY: in std_logic_vector(31 downto 0);
RGB: out std_logic_vector(11 downto 0);
drw: out std_logic);
end component;

component Score
port(
clk,rst: in     std_logic;
Pin,Nin: in     std_Logic;
outpt:   out	 std_logic_vector(11 downto 0):="000000000000");
end component;

-- Components --

-- signals --

signal clk_108: 	std_logic;
signal sR: 		 	std_logic_vector(3  downto 0);
signal sG: 		 	std_logic_vector(3  downto 0);
signal sB: 		 	std_logic_vector(3  downto 0);
signal RGB:		 	std_logic_vector(11 downto 0);
signal X,Y:		 	std_logic_vector(31 downto 0);

signal RGB_Cur: 	std_logic_vector(11 downto 0);
signal GO_RGB: 	std_logic_vector(11 downto 0);
signal drw_Cur: 	std_logic;
signal GO_drw,mskGO:	std_logic;

signal hit1:		 	std_logic;
signal hit2:		 	std_logic;

signal loadRed,selRed:    std_logic;
signal rRed,lRed:		     std_logic;
signal RstrX,RstpX,RposY: std_logic_vector(31 downto 0);
signal RedX1,  RedY1:     std_logic_vector(31 downto 0);
signal RedX2,  RedY2:     std_logic_vector(31 downto 0);
signal BlueX1, BlueY1:    std_logic_vector(31 downto 0);
signal drwBlue: 		     std_logic;
signal drwRed:			     std_logic;

signal seg1,seg2,seg5,seg6: std_logic_vector(3 downto 0);

signal FilteredHit1: std_logic;
signal FilteredHit2: std_logic;

signal l1drw1,l1drw2,l2drw1,l2drw2,l3drw1,l3drw2: std_logic;
signal l4drw,l5drw,l6drw: std_logic;
signal RGBl11, RGBl12,RGBl21,RGBl22,RGBl31,RGBl32: std_logic_vector(11 downto 0);
signal RGBl4,RGBl5,RGBl6: std_logic_vector(11 downto 0);
signal sgr,gr: std_logic_vector(11 downto 0);

signal scr: std_logic_vector(11 downto 0);

signal LoadRpos: std_logic;
-- signals --

begin
U1:   VGA_Controller  port map (sR,sG,sB,rst,clk_108,R,G,B,X,Y,H_Sync,V_Sync);
U2:   PLL				 port map (not rst,clk_50,clk_108);

U3:   Priority_Draw   port map (rst,clk_108,
										  drw_Cur,
										  l1drw1 and drwRed, l1drw2 and drwBlue,
										  GO_drw and mskGO, l2drw2,
										  l3drw1, l3drw2,
										  l4drw, l5drw, l6drw,
										  RGB_Cur,
										  RGBl11, RGBl12,
										  GO_RGB, RGBl22,
										  RGBl31, RGBl32,
										  RGBl4,RGBl5,RGBl6,
										  gr,RGB); -- gr = "000011110000"

l2drw1 <= '0';
l2drw2 <= '0';
l3drw1 <= '0';
l3drw2 <= '0';
l4drw  <= '0';
l5drw  <= '0';
l6drw  <= '0';

U4:   CursorUnit		 port map (rst,clk_108,u,d,l,ri,X,Y,RGB_Cur,drw_Cur,open);
U5:   TargetRed		 port map (clk_108,RedX1,RedY1,X,Y,RGBl11,l1drw1);
U6:	TargetBlue		 port map (clk_108,BlueX1,BlueY1,X,Y,RGBl12,l1drw2);
U7:   FSM_Game		    port map (rst,clk_108,FilteredHit1,FilteredHit2,clk_50,RedX1,RedY1,BlueX1,BlueY1,seg1,seg2,drwBlue,drwRed,mskGO,seg5,seg6);
U8:   Filter			 port map (clk_50,rst,hit1,FilteredHit1);
U9:   Filter			 port map (clk_50,rst,hit2,FilteredHit2);
U10:  Score				 port map (clk_50,rst,FilteredHit1,FilteredHit2,scr);
bg:	Background		 port map (clk_108,X,Y,gr);

SEGM1: Segment_Decoder port map (seg1,HEX1);
SEGM2: Segment_Decoder port map (seg2,HEX2);

--Score2Segment
SEGM3: Segment_Decoder port map (scr(3 downto 0),HEX3);
SEGM4: Segment_Decoder port map (scr(7 downto 4),HEX4);

--Timer2Segment Decoder:
SEGM5: Segment_Decoder port map (seg5,HEX5);
SEGM6: Segment_Decoder port map (seg6,HEX6);

GO:    GAMEOVER port map (clk_108,X,Y,x"000001CE",x"000001D5",GO_RGB,GO_drw);

sR <= RGB(11 downto 8);
sG <= RGB(7  downto 4);
sB <= RGB(3  downto 0);

hit1 <= (not hitSW) and l1drw1 and drw_Cur;
hit2 <= (not hitSW) and (l1drw2 and drwBlue) and drw_Cur;
end;