-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definición entidad testbench: entidad vacía

entity lcd_ctrl_tb is

end lcd_ctrl_tb;

-- Definición arquitectura 
architecture arch_lcd_ctrl_tb of lcd_ctrl_tb is
-- Declaración del módulo que queremos testear con sus entradas y saidas
component mod_uart is 
   port
      (
            clk,reset_l:  in std_logic;

            -- In
            LCD_init_done, OP_SETCURSOR, OP_DRAWCOLOUR:   in std_logic;
            XCOL:                                         in unsigned ( 7 downto 0);
            YROW:                                         in unsigned ( 8 downto 0);
            RGB:                                          in unsigned ( 15 downto 0);
            NUM_PIX:                                      in unsigned ( 16 downto 0);
          
            -- Out
          
            DONE_CURSOR, DONE_COLOUR, LCD_CS_N, LCD_WR_N, LCD_RS:   out std_logic;
            LCD_DATA:                                               out unsigned ( 15 downto 0)
      );
end component;
-- Declaración de las señales que vamos conectar al módulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del módulo.
signal LCD_init_done, OP_SETCURSOR, OP_DRAWCOLOUR:   std_logic;
signal XCOL:         unsigned ( 7 downto 0);
signal YROW:         unsigned ( 8 downto 0);
signal RGB:          unsigned ( 15 downto 0);
signal NUM_PIX:      unsigned ( 16 downto 0);


signal DONE_CURSOR, DONE_COLOUR, LCD_CS_N, LCD_WR_N, LCD_RS:   std_logic;
signal LCD_DATA:                                               unsigned ( 15 downto 0);


signal reset_l : std_logic:='1';
-- A la señal de reloj se le da un un valor inicial. Al resto de entradas del
-- módulo no es necesario, pero se puede hacer.

signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura

-- Mapeamos las señales internas con las entradas salidas del módulo .
DUT: mod_uart port map (
      LCD_init_done     =>LCD_init_done,
      XCOL              => XCOL,
      YROW              => YROW,
      RGB               => RGB,
      NUM_PIX           => NUM_PIX,
      OP_SETCURSOR      => OP_SETCURSOR,
      OP_DRAWCOLOUR     => OP_DRAWCOLOUR,

      clk=>CLK,
      reset_l=>reset_l,

      DONE_CURSOR => DONE_CURSOR,
      DONE_COLOUR => DONE_COLOUR,
      LCD_CS_N => LCD_CS_N,
      LCD_WR_N => LCD_WR_N,
      LCD_RS => LCD_RS,
      LCD_DATA => LCD_DATA

);

-- Definición de la señal de reloj mediante una asignación concurrente
CLK<= not CLK after 10 ns; 

-- Definición de un proceso en el que vamos dando diferentes valores a las 
-- señales de entrada del módulo a lo largo del tiempo. 
-- Uso de la sentencia "wait" para mantener los valores el tiempo necesario.

process
begin

OP_SETCURSOR <= '0';
OP_DRAWCOLOUR <= '0';
NUM_PIX     <= (others => '0');
XCOL        <= (others => '0');
YROW        <= (others => '0');
RGB         <= (others => '0');
LCD_init_done <= '0';

XCOL <= X"78";
YROW <= '1' & X"A8";

reset_l<='0';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';
wait for 20 ns; 

OP_SETCURSOR <= '1';
LCD_init_done <= '1';
RGB <= X"CAFE";
NUM_PIX <= '0' & X"0002";
wait for 20 ns;
OP_SETCURSOR <= '0';

wait for 1020 ns;
OP_DRAWCOLOUR <= '1';
wait for 20 ns;
OP_DRAWCOLOUR <= '0';

wait for 1020 ns;
OP_SETCURSOR <= '1';
wait for 20 ns;
OP_SETCURSOR <= '0';
wait for 20 ns;

wait;



end process;


end arch_lcd_ctrl_tb;

