library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Constantes de los colores
-- Son 16 bits, 5 para rojo, 6 para verde y 5 para azul



entity LCD_DRAWING is 

port(
    Clk,RESET_L: in STD_LOGIC;
    COLOUR_CODE: in unsigned(2 downto 0);
    DEL_SCREEN,DRAW_FIG,DONE_CURSOR,DONE_COLOUR: in std_logic;
    OP_SETCURSOR,OP_DRAWCOLOUR: out STD_LOGIC;
    XCOL: out unsigned(7 downto 0);
    YROW: out unsigned(8 downto 0);
    RGB:out unsigned(15 downto 0);
    NUM_PIX: out unsigned(16 downto 0)
);

end LCD_DRAWING;

architecture arch_LCD_DRAWING of LCD_DRAWING is
    type estado is (E_W8_CMD, E_DELCURSOR, E_DELCOLOR, E_FIGCURSOR, E_FIGCOLOUR);
    signal epres,esig: estado;

    signal MUX_val: std_logic;
    signal LD_TRIA,INC_XYTRIA,DEC_TRIA_PIX,MUX_CLR,MUX_PRS,END_TRIA: std_logic;
    signal XTRIA: unsigned(7 downto 0);
    signal YTRIA: unsigned(8 downto 0);
    signal TRIA_PIX: unsigned(16 downto 0);

  
 constant NEGRO : unsigned(15 downto 0) := X"0000";
 constant ROJO  : unsigned(15 downto 0) := X"F800";
 constant VERDE : unsigned(15 downto 0) := X"07E0";
 constant AZUL : unsigned(15 downto 0)  := X"001F";
 constant CIAN : unsigned(15 downto 0)  := X"07FF";
 constant AMARILLO: unsigned(15 downto 0)  := X"FFE0";
 constant MAGENTA: unsigned(15 downto 0)  := X"F81F";
 constant BLANCO: unsigned(15 downto 0)  := X"FFFF";

 constant XTRIA_IN:  unsigned(7 downto 0):= to_unsigned(10,8);
 constant YTRIA_IN: unsigned(8 downto 0):= to_unsigned(15,9);
 constant TRIA_PIX_IN: unsigned(16 downto 0):=to_unsigned(101,17);
 
 
begin


-----------------------
-- UNIDAD DE CONTROL --
-----------------------

-- proceso sincrono que actualiza el estado en flanco de reloj. Reset as�ncrono.
process (clk,RESET_L)
begin
  if RESET_L='0' then epres<=E_W8_CMD;
    elsif clk'event and clk='1' then epres<=esig;
  end if;
end process;





  -- proceso combinacional que determina el estado siguiente
  process (epres,DEL_SCREEN,DRAW_FIG,DONE_CURSOR,DONE_COLOUR,END_TRIA)
    begin
      case epres is 
      -- una clausula when por cada estado
      when E_W8_CMD => 
        
        if (DEL_SCREEN='1' and DRAW_FIG='0') then     esig<=E_DELCURSOR;
		    elsif (DEL_SCREEN='0' and DRAW_FIG='1') then  esig<=E_FIGCURSOR;
        else                                          esig<=E_W8_CMD;
        end if;
      when E_DELCURSOR => 
        if DONE_CURSOR='1' then esig<= E_DELCOLOR;
        else                          esig<=E_DELCURSOR;
        end if;
      when E_DELCOLOR => 
        if DONE_COLOUR='1' then esig<= E_W8_CMD;
        else                          esig<=E_DELCOLOR;
        end if;
      when E_FIGCURSOR => 
        if DONE_CURSOR='1' then esig<=E_FIGCOLOUR;
        else                          esig<=E_FIGCURSOR;
        end if;
      when E_FIGCOLOUR => 
        if DONE_COLOUR='1' then
          if END_TRIA='1' then esig<=E_W8_CMD;
          else                  esig<=E_FIGCURSOR;
          end if;
        else                  esig<=E_FIGCOLOUR;
        end if;
      when others => esig<=epres;
    end case;
    end process;


OP_SETCURSOR<='1' when (epres=E_DELCURSOR or epres=E_FIGCURSOR) else '0';

OP_DRAWCOLOUR<='1' when (epres=E_DELCOLOR or epres=E_FIGCOLOUR) else '0';

LD_TRIA<='1' when (epres=E_W8_CMD and DEL_SCREEN='0' and DRAW_FIG='1') else '0';

INC_XYTRIA<='1' when (epres=E_FIGCURSOR and DONE_CURSOR='1') else '0';

MUX_CLR<='1' when(epres=E_W8_CMD and DEL_SCREEN='1') else '0';

MUX_PRS<='1' when(epres=E_W8_CMD and DEL_SCREEN='0' and DRAW_FIG='1') else '0';

DEC_TRIA_PIX<='1' when(epres=E_FIGCOLOUR and DONE_COLOUR='1' and END_TRIA='0') else '0';


--constantes


-----------------------
-- UNIDAD DE PROCESO --
-----------------------

-- Multiplexor de salidas
NUM_PIX <= TRIA_PIX when (MUX_val = '1') else to_unsigned(76800,17);
XCOL <= XTRIA when (MUX_val = '1') else to_unsigned(0,8);
YROW <= YTRIA when (MUX_val = '1') else to_unsigned(0,9);





--CONTADOR XTRIA,YTRIA
process (clk,RESET_L)
begin
if RESET_L='0' then XTRIA<=X"00"; YTRIA<='0' & X"00";
elsif clk'event and clk='1' then
  if LD_TRIA='1' then XTRIA<=XTRIA_IN; YTRIA<=YTRIA_IN;
  elsif INC_XYTRIA='1' then
    XTRIA <= XTRIA+1; YTRIA<=YTRIA+1;
  end if;
end if;
end process;


--CONTADOR TRIA_PIX
process (clk,RESET_L)
begin
if RESET_L='0' then TRIA_PIX<=to_unsigned(0,17);
elsif clk'event and clk='1' then
  if LD_TRIA='1' then TRIA_PIX<=TRIA_PIX_IN;
  elsif DEC_TRIA_PIX='1' then
    TRIA_PIX <= TRIA_PIX-2;
  end if;
end if;
end process;
END_TRIA<='1' when (TRIA_PIX=to_unsigned(1,17)) else '0';


-- Biestable MUX_val
process (clk,RESET_L)
begin
 if RESET_L='0' then MUX_val<='0';
  elsif clk'event and clk='1' then
    if MUX_PRS='1' then MUX_val<='1';
    elsif MUX_CLR='1' then MUX_val<='0';
    end if;
end if;
end process;


         

RGB<=AZUL when COLOUR_CODE="001" else
     VERDE when COLOUR_CODE="010" else
     CIAN when COLOUR_CODE="011" else
     ROJO when COLOUR_CODE="100" else
     MAGENTA when COLOUR_CODE="101" else
     AMARILLO when COLOUR_CODE="110" else
     BLANCO when COLOUR_CODE="111" else NEGRO;


end arch_LCD_DRAWING;


