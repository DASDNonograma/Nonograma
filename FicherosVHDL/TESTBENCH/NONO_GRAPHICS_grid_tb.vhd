-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definición entidad testbench: entidad vacía

entity nono_graphics_grid_tb is

end nono_graphics_grid_tb;

-- Definición arquitectura 
architecture arch_nono_graphics_grid_tb of nono_graphics_grid_tb is
-- Declaración del módulo que queremos testear con sus entradas y saidas
component NONO_GRAPHICS_grid is 
   port(
      clk,reset_l:  in std_logic;

      -- In
      GRID_OP:  in std_logic;
      DONE_DEL: in std_logic;
      DONE_FIG: in std_logic;

      -- Out
  
      XCOOR:        out unsigned(7 downto 0);
      YCOOR:        out unsigned(8 downto 0);
      COLOUR_CODE:  out std_logic_vector(2 downto 0);
      DONE_GRID:    out std_logic;
      DEL_SCREEN:   out std_logic;
      DRAW_CUAD:    out std_logic;
      DRAW_TRIA:    out std_logic;
      DRAW_LINE, VERTICAL: out std_logic
    
      );
end component;
-- Declaración de las señales que vamos conectar al módulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del módulo.
signal GRID_OP: std_logic:='0';
signal DONE_DEL: std_logic:='0';
signal DONE_FIG: std_logic:='0';

signal XCOOR: unsigned(7 downto 0);
signal YCOOR: unsigned(8 downto 0);
signal COLOUR_CODE: std_logic_vector(2 downto 0);
signal DONE_GRID: std_logic;
signal DEL_SCREEN: std_logic;
signal DRAW_CUAD: std_logic;
signal DRAW_TRIA: std_logic;
signal DRAW_LINE, VERTICAL: std_logic;



signal reset_l : std_logic:='1';
signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura

-- Mapeamos las señales internas con las entradas salidas del módulo .
DUT: NONO_GRAPHICS_grid port map (
      clk => CLK,
      reset_l => reset_l,

      GRID_OP => GRID_OP,
      DONE_DEL => DONE_DEL,
      DONE_FIG => DONE_FIG,

      XCOOR => XCOOR,
      YCOOR => YCOOR,
      COLOUR_CODE => COLOUR_CODE,
      DONE_GRID => DONE_GRID,
      DEL_SCREEN => DEL_SCREEN,
      DRAW_CUAD => DRAW_CUAD,
      DRAW_TRIA => DRAW_TRIA,
      DRAW_LINE => DRAW_LINE,
      VERTICAL => VERTICAL

);

-- Definición de la señal de reloj mediante una asignación concurrente
CLK<= not CLK after 10 ns; 

-- Definición de un proceso en el que vamos dando diferentes valores a las 
-- señales de entrada del módulo a lo largo del tiempo. 
-- Uso de la sentencia "wait" para mantener los valores el tiempo necesario.

process
begin

reset_l<='0';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';
wait for 20 ns; 
GRID_OP<='1';
wait for 50 ns;
grid_op<='0';
done_del<='1';
wait for 50 ns;
done_del<='0';
done_fig<='1';
wait for 50 ns;



wait;



end process;


end arch_nono_graphics_grid_tb;

