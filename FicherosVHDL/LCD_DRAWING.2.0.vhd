library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LCD_DRAWING is 

port(
    Clk,RESET_L : in STD_LOGIC;
    --IN
    COLOUR_CODE : in unsigned(2 downto 0);
    DEL_SCREEN,DRAW_TRIA,DONE_CURSOR,DONE_COLOUR,DRAW_CUAD,DRAW_LINE,VERTICAL : in std_logic;
    XCOR : in unsigned(7 downto 0);
    YCOR : in unsigned(8 downto 0);
    --OUT
    OP_SETCURSOR, OP_DRAWCOLOUR : out STD_LOGIC;
    DONE_FIG, DONE_DEL : out std_logic;
    XCOL : out unsigned(7 downto 0);
    YROW : out unsigned(8 downto 0);
    RGB : out unsigned(15 downto 0);
    NUM_PIX : out unsigned(16 downto 0)
);

end LCD_DRAWING;

architecture arch_LCD_DRAWING of LCD_DRAWING is
    type estado is (E_CL_FIG,E_W8_CMD,E_LINE_PIX,E_DELCURSOR,E_DELCOLOUR,E_FIGCURSOR,E_FIGCOLOUR, E_DONE_FIG);
    signal epres,esig: estado;

    signal LD_TRIA,LD_CUAD,LD_LINE,LD_LINE_PIX,CL_FIG,INC_CUAD,INC_XYTRIA,INC_LINE,DEC_LINE_PIX,DEC_CUAD_PIX,DEC_TRIA_PIX,END_TRIA,END_LINE,END_CUAD: std_logic;
    signal XCUAD,XLINE,XTRIA: unsigned(7 downto 0);
    signal YCUAD,YLINE,YTRIA: unsigned(8 downto 0);
    signal RVERTICAL,SEL_CUAD,SEL_LINE,SEL_TRIA,SEL_DEL: std_logic;
    signal TRIA_PIX_IN,TRIA_PIX,CUAD_PIX_IN,CUAD_PIX,LINE_PIX,LINE_PIX_HOR,LINE_PIX_VER: unsigned(16 downto 0);
    signal SEL_FIG: unsigned(1 downto 0);
begin

-----------------------
-- UNIDAD DE CONTROL --
-----------------------

-- proceso sincrono que actualiza el estado en flanco de reloj. Reset as�ncrono.
process (clk,RESET_L)
begin
  if RESET_L='0' then epres<=E_CL_FIG;
    elsif clk'event and clk='1' then epres<=esig;
  end if;
end process;





  -- proceso combinacional que determina el estado siguiente
  process (epres,DEL_SCREEN,DRAW_TRIA,DRAW_CUAD,DRAW_LINE,DONE_CURSOR,DONE_COLOUR,SEL_FIG,END_TRIA,RVERTICAL,END_LINE,END_CUAD)
    begin
      case epres is
  when E_DONE_FIG => esig<=E_CL_FIG;
	when E_CL_FIG=> esig<=E_W8_CMD;
      -- una clausula when por cada estado
        when E_W8_CMD => if DEL_SCREEN='1' then esig<=E_DELCURSOR;
		          elsif (DRAW_TRIA='1' OR DRAW_CUAD='1')  then esig<=E_FIGCURSOR;
              elsif (DRAW_LINE='1') then esig<=E_LINE_PIX;
			        else esig<=E_W8_CMD;
				              end if;
      when E_LINE_PIX => esig<=E_FIGCURSOR;
      when E_DELCURSOR => if DONE_CURSOR='1' then esig<= E_DELCOLOUR;
                       else esig<=E_DELCURSOR;
                       end if;
      when E_DELCOLOUR => if DONE_COLOUR='1' then esig<= E_W8_CMD;
                        else esig<=E_DELCOLOUR;
                        end if;
      when E_FIGCURSOR => if DONE_CURSOR='1' then esig<=E_FIGCOLOUR;
                        else esig<=E_FIGCURSOR;
                        end if;
      when E_FIGCOLOUR => if DONE_COLOUR='1' then
                            if (SEL_FIG="01" and END_TRIA='1') OR (SEL_FIG="11" and END_LINE='1')  OR (SEL_FIG="10" and END_CUAD='1') then esig<=E_DONE_FIG;
                            else esig<=E_FIGCURSOR;
                            end if;
                          else esig<=E_FIGCOLOUR;
                          end if;
      when others => esig<=epres;
    end case;
    end process;


--seinales de control de estado

--OP
OP_SETCURSOR<='1' when (epres=E_DELCURSOR or epres=E_FIGCURSOR) else '0';

OP_DRAWCOLOUR<='1' when (epres=E_DELCOLOUR or epres=E_FIGCOLOUR) else '0';

--ACK para LCD_NONO
DONE_DEL<='1' when (epres=E_DELCOLOUR and DONE_COLOUR='1') else '0';

DONE_FIG<='1' when (epres=E_DONE_FIG) else '0';

--Load Registros Figuras
LD_TRIA<='1' when (epres=E_W8_CMD and DRAW_TRIA='1') else '0';

LD_CUAD<='1' when (epres=E_W8_CMD and DRAW_CUAD='1') else '0';

LD_LINE<='1' when (epres=E_W8_CMD and DRAW_LINE='1') else '0';

LD_LINE_PIX<='1' when (epres=E_LINE_PIX) else '0';

--Inc Registros X,Y COR
INC_XYTRIA<='1' when (epres=E_FIGCURSOR and DONE_CURSOR='1' and SEL_FIG="01") else '0';

INC_CUAD<='1' when (epres=E_FIGCURSOR and DONE_CURSOR='1' and SEL_FIG="10") else '0';

INC_LINE<='1' when (epres=E_FIGCURSOR and DONE_CURSOR='1' and SEL_FIG="11") else '0';

--Dec Contadores Pixels Figuras
DEC_TRIA_PIX<='1' when(epres=E_FIGCOLOUR and DONE_COLOUR='1' and END_TRIA='0' and SEL_FIG="01") else '0';

DEC_CUAD_PIX<='1' when(epres=E_FIGCOLOUR and DONE_COLOUR='1' and END_CUAD='0' and SEL_FIG="10") else '0';

DEC_LINE_PIX<='1' when(epres=E_FIGCOLOUR and DONE_COLOUR='1' and END_LINE='0' and SEL_FIG="11") else '0';


--CL Registros
CL_FIG<='1' when (epres=E_CL_FIG) else '0';

--Del Screen mode
SEL_DEL<='1' when ((epres=E_W8_CMD and DEL_SCREEN='1') or epres=E_DELCURSOR or epres=E_DELCOLOUR) else '0';


-----------------------
-- UNIDAD DE PROCESO --
-----------------------


--constantes
TRIA_PIX_IN<=to_unsigned(17,17);
CUAD_PIX_IN<=to_unsigned(17,17);
LINE_PIX_HOR<=to_unsigned(214,17);
LINE_PIX_VER<=to_unsigned(4,17);

--CONTADOR XTRIA,YTRIA
process (clk,RESET_L)
begin
if (RESET_L='0') then XTRIA<=X"00"; YTRIA<='0' & X"00";
elsif clk'event and clk='1' then
if (CL_FIG='1') then XTRIA<=X"00"; YTRIA<='0' & X"00";
elsif LD_TRIA='1' then XTRIA<=XCOR; YTRIA<=YCOR;
elsif INC_XYTRIA='1' then
XTRIA <= XTRIA+1; YTRIA<=YTRIA+1;
end if;
end if;
end process;


--CONTADOR TRIA_PIX
process (clk,RESET_L)
begin
if (RESET_L='0') then TRIA_PIX<=to_unsigned(0,17);
elsif clk'event and clk='1' then
if (CL_FIG='1') then TRIA_PIX<=to_unsigned(0,17);
elsif LD_TRIA='1' then TRIA_PIX<=TRIA_PIX_IN;
elsif DEC_TRIA_PIX='1' then
TRIA_PIX <= TRIA_PIX-2;
end if;
end if;
end process;
END_TRIA<='1' when (TRIA_PIX=to_unsigned(1,17)) else '0';


--CONTADOR YCUAD/REGISTRO XCUAD
process (clk,RESET_L)
begin
if (RESET_L='0') then XCUAD<=X"00"; YCUAD<='0' & X"00";
elsif clk'event and clk='1' then
if (CL_FIG='1') then XCUAD<=X"00"; YCUAD<='0' & X"00";
elsif LD_CUAD='1' then XCUAD<=XCOR; YCUAD<=YCOR;
elsif INC_CUAD='1' then
 YCUAD<=YCUAD+1;
end if;
end if;
end process;

--CONTADOR CUAD_PIX
process (clk,RESET_L)
begin
if (RESET_L='0') then CUAD_PIX<=to_unsigned(0,17);
elsif clk'event and clk='1' then
if (CL_FIG='1') then CUAD_PIX<=to_unsigned(0,17);
elsif LD_CUAD='1' then CUAD_PIX<=CUAD_PIX_IN;
elsif DEC_CUAD_PIX='1' then
CUAD_PIX <= CUAD_PIX-1;
end if;
end if;
end process;
END_CUAD<='1' when (CUAD_PIX=to_unsigned(1,17)) else '0';


--CONTADOR YLINE/REGISTRO XLINE
process (clk,RESET_L)
begin
if (RESET_L='0') then XLINE<=X"00"; YLINE<='0' & X"00";
elsif clk'event and clk='1' then
if (CL_FIG='1') then XLINE<=X"00"; YLINE<='0' & X"00";
elsif LD_LINE='1' then XLINE<=XCOR; YLINE<=YCOR;
elsif (INC_LINE='1') then
 YLINE<=YLINE+1;
end if;
end if;
end process;

--CONTADOR LINE_PIX
process (clk,RESET_L)
begin
if (RESET_L='0') then LINE_PIX<=to_unsigned(0,17);
elsif clk'event and clk='1' then
if (CL_FIG='1') then LINE_PIX<=to_unsigned(0,17);
elsif (LD_LINE_PIX='1') then 
  if(RVERTICAL='1') then LINE_PIX<=LINE_PIX_HOR;
  else LINE_PIX<=LINE_PIX_VER;
  end if;
elsif DEC_LINE_PIX='1' then
LINE_PIX <= LINE_PIX-1;
end if;
end if;
end process;
END_LINE<='1' when (LINE_PIX=to_unsigned(1,17)) else '0';

--BIESTABLE VERTICAL
process (clk,RESET_L)
begin
if RESET_L='0' then RVERTICAL<='0';
elsif clk'event and clk='1' then
if LD_LINE='1' then RVERTICAL<=VERTICAL;
end if;
end if;
end process;


--BIESTABLES SEL_CUAD,SEL_FIG,SEL_LINE,SEL_DEL
process (clk,RESET_L)
begin
if (RESET_L='0') then SEL_CUAD<='0';SEL_TRIA<='0';SEL_LINE<='0';
elsif clk'event and clk='1' then
if (CL_FIG='1') then SEL_CUAD<='0';SEL_TRIA<='0';SEL_LINE<='0';
elsif LD_CUAD='1' then SEL_CUAD<='1';
elsif LD_LINE='1' then SEL_LINE<='1';
elsif LD_TRIA='1' then SEL_TRIA<='1';
end if;
end if;
end process;


--MUX NUM_PIX,YROW,XCOL,RGB;

SEL_FIG<="01" when SEL_TRIA='1' else
          "10" when SEL_CUAD='1' else
         "11" when SEL_LINE='1' else
	 "00";

NUM_PIX<=TRIA_PIX when  SEL_TRIA='1' else
         CUAD_PIX_IN when SEL_CUAD='1' else
         LINE_PIX_HOR when (SEL_LINE='1' and RVERTICAL='0') else
         LINE_PIX_VER when (SEL_LINE='1' and RVERTICAL='1') else
         to_unsigned(76800,17) when SEL_DEL='1' else
         to_unsigned(0,17);

YROW<=YTRIA when  SEL_TRIA='1' else
         YCUAD when SEL_CUAD='1' else
         YLINE when SEL_LINE='1' else
         to_unsigned(0,9);

XCOL<=XTRIA when  SEL_TRIA='1' else
         XCUAD when SEL_CUAD='1' else
         XLINE when SEL_LINE='1' else
         to_unsigned(0,8);



RGB<= '0' & X"0" & "00" & X"0" & '1' & X"F" when COLOUR_CODE="001" else
      '0' & X"0" & "11" & X"F" & '1' & X"F" when COLOUR_CODE="010" else
      '0' & X"0" & "11" & X"F" & '1' & X"F"when COLOUR_CODE="011" else
      '1' & X"F" & "00" & X"0" & '0' & X"0"when COLOUR_CODE="100" else
      '1' & X"F" & "00" & X"0" & '1' & X"F"when COLOUR_CODE="101" else
      '1' & X"F" & "11" & X"F" & '0' & X"0"when COLOUR_CODE="110" else
      '1' & X"F" & "11" & X"F" & '1' & X"F"when COLOUR_CODE="111" else 
      X"0000";


end arch_LCD_DRAWING;


