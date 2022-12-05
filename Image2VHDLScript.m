strimg = input('Enter image name:\n','s');
FileName = input('Enter file name:\n','s');
Ent = input('Enter Entity name:\n','s');
val = input('Enter 1/0 to enable color mode:\n');

Target1 = imread(strimg);

sz = floor(size(Target1));
andmat = uint16( 240 * ones(sz(1),sz(2)) );

RTarget1 = uint16(Target1(:,:,1));
GTarget1 = uint16(Target1(:,:,2));
BTarget1 = uint16(Target1(:,:,3));

RTarget1 = bitand(RTarget1,andmat) * 16;
GTarget1 = bitand(GTarget1,andmat);
BTarget1 = bitand(BTarget1,andmat) / 16;

RGBTar1 = bitor(RTarget1 , GTarget1);
RGBTar1 = bitor(RGBTar1  , BTarget1);
%%
if (val)
    for i=1:1:sz(1)
      for j=1:1:sz(2)
          if (RGBTar1(i,j) == 1911)
              RGBTar1(i,j) = 0;
          end
      end
    end
end
%%
FileID = fopen(FileName,'w');
fprintf(FileID,'library ieee;\n');
fprintf(FileID,'use ieee.std_Logic_1164.all;\n');
fprintf(FileID,'use ieee.std_logic_unsigned.all;\n');
fprintf(FileID,'use ieee.std_Logic_arith.all;\n\n');
fprintf(FileID,'entity %s is\n',Ent);
fprintf(FileID,'port(\n');
fprintf(FileID,'clk: in std_logic;\n');
fprintf(FileID,'Xpxl,Ypxl: in std_logic_vector(10 downto 0);\n');
fprintf(FileID,'topX,topY: in std_logic_vector(10 downto 0);\n');
fprintf(FileID,'RGB: out std_logic_vector(11 downto 0);\n');
fprintf(FileID,'drw: out std_logic);\nend;\n\n');

fprintf(FileID,'architecture one of %s is\n',Ent);
fprintf(FileID,'type mat is array (0 to %d, 0 to %d) of integer range 0 to 4095;\n',sz(1)-1,sz(2)-1);
fprintf(FileID,'signal sRGB: mat :=\n');

fprintf(FileID,'(\n');

for i=1:1:sz(1)
    fprintf(FileID,'(');
    for j=1:1:sz(2)
        fprintf(FileID,'%d',RGBTar1(i,j));
        if (j ~= sz(2))
            fprintf(FileID,',');
        end
    end
    fprintf(FileID,')');
    if (i ~= sz(1))
        fprintf(FileID,',\n');
    else
        fprintf(FileID,'\n');
    end
end
fprintf(FileID,');\n\n');
fprintf(FileID,'begin\n\n');

fprintf(FileID,'process(clk)\nvariable Xoff,Yoff:std_logic_vector(10 downto 0);\nbegin\n');
fprintf(FileID,"if (clk 'event and clk = '1') then\n");
fprintf(FileID,'\tXoff := Xpxl - topX;\n\tYoff := Ypxl - topY;\n');
fprintf(FileID,'\tif ( (Xpxl > topX) and (Xpxl < topX + %d) and (Ypxl > topY) and (Ypxl < topY + %d) ) then\n',sz(2)-1,sz(1) - 1);
fprintf(FileID,'\t\tif ( sRGB( conv_integer(Yoff) , conv_integer(Xoff) ) = 0 ) then\n');
fprintf(FileID,"\t\t\tdrw <= '0';\n\t\telse\n\t\t\tdrw <= '1';\n");
fprintf(FileID,'\t\t\tRGB <= conv_std_logic_vector(sRGB(conv_integer(Yoff),conv_integer(Xoff)),12);\n');
fprintf(FileID,"\t\tend if;\n\telse\n\t\tdrw <= '0';\n\tend if;\nend if;\nend process;\nend;");
fclose(FileID);

imshow(Target1)