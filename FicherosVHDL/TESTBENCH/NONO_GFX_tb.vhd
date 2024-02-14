-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definición entidad testbench: entidad vacía

entity nono_GFX_tb is

end nono_GFX_tb;

-- Definición arquitectura 
architecture arch_nono_GFX_cursor_tb of nono_GFX_tb is
-- Declaración del módulo que queremos testear con sus entradas y saidas
component NONO_GFX is
  port (
	clk,reset_l:  in std_logic;

  -- in
  CMD_PX_GO: in std_logic;
  INI_NONO: in std_logic;
  COMMAND: in std_logic_vector(2 downto 0);
  CURSORX, CURSORY: in unsigned(3 downto 0);
  UPDATE_CURSOR, TOGGLE_CURSOR: in std_logic;
  DONE_FIG, DONE_DEL: in std_logic;

  -- OUT

  XCOOR:        out unsigned(7 downto 0);
  YCOOR:        out unsigned(8 downto 0);
  COLOUR_CODE:  out unsigned(2 downto 0);
  DRAW_CUAD, DRAW_TRIA, DRAW_LINE, VERTICAL: out std_logic;
  DEL_SCREEN:   out std_logic;
  DONE_UPDATE, DONE_TOGGLE: out std_logic
 
  );
end component;


-- Declaración de las señales que vamos conectar al módulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del módulo.

signal CMD_PX_GO: std_logic:='0';
signal INI_NONO: std_logic:='0';
signal COMMAND: std_logic_vector(2 downto 0):="000";
signal CURSORX, CURSORY: unsigned(3 downto 0):="0000";
signal UPDATE_CURSOR, TOGGLE_CURSOR: std_logic:='0';
signal DONE_FIG, DONE_DEL: std_logic:='0';

signal XCOOR: unsigned(7 downto 0);
signal YCOOR: unsigned(8 downto 0);
signal COLOUR_CODE: unsigned(2 downto 0);
signal DRAW_CUAD, DRAW_TRIA, DRAW_LINE, VERTICAL: std_logic;
signal DEL_SCREEN: std_logic;
signal DONE_UPDATE, DONE_TOGGLE: std_logic;




signal reset_l : std_logic:='1';
-- A la señal de reloj se le da un un valor inicial. Al resto de entradas del
-- módulo no es necesario, pero se puede hacer.

signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura



-- Definición de la señal de reloj mediante una asignación concurrente
CLK<= not CLK after 10 ns; 
-- En el testbench vamos a probar lo siguiente:


DUT: NONO_GFX port map(
  clk=>CLK,
  reset_l=>reset_l,
  CMD_PX_GO=>CMD_PX_GO,
  INI_NONO=>INI_NONO,
  COMMAND=>COMMAND,
  CURSORX=>CURSORX,
  CURSORY=>CURSORY,
  UPDATE_CURSOR=>UPDATE_CURSOR,
  TOGGLE_CURSOR=>TOGGLE_CURSOR,
  DONE_FIG=>DONE_FIG,
  DONE_DEL=>DONE_DEL,
  XCOOR=>XCOOR,
  YCOOR=>YCOOR,
  COLOUR_CODE=>COLOUR_CODE,
  DRAW_CUAD=>DRAW_CUAD,
  DRAW_TRIA=>DRAW_TRIA,
  DRAW_LINE=>DRAW_LINE,
  VERTICAL=>VERTICAL,
  DEL_SCREEN=>DEL_SCREEN,
  DONE_UPDATE=>DONE_UPDATE,
  DONE_TOGGLE=>DONE_TOGGLE
  );



process
begin



reset_l<='0';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';
wait for 40 ns; 
ini_nono<='1';
wait for 40 ns;
ini_nono<='0';
wait for 40 ns;
done_del<='1';
wait for 40 ns;
done_del<='0';
done_fig<='1';
wait for 40 ns;



wait;



end process;


end arch_nono_GFX_cursor_tb;

