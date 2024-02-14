-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definición entidad testbench: entidad vacía

entity lcd_sintest_tb is

end lcd_sintest_tb;

-- Definición arquitectura 
architecture arch_lcd_sintest_tb of lcd_sintest_tb is
-- Declaración del módulo que queremos testear con sus entradas y saidas
component LCD_SINTEST is 
   port
      (
            clk,reset_l:  in std_logic;

            -- In 
            DONE_COLOUR: in std_logic;
            DONE_CURSOR: in std_logic;
            -- OUT
            OP_SETCURSOR: out std_logic;
            XCOL: out unsigned (7 downto 0);
            YROW: out unsigned (8 downto 0);
            OP_DRAWCOLOUR: out std_logic;
            NUMPIX: out unsigned (16 downto 0);
            RGB: out unsigned (15 downto 0)
      );
end component;

-- Declaración de las señales que vamos conectar al módulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del módulo.


signal reset_l : std_logic:='1';
signal CLK: std_logic:='0';

signal DONE_COLOUR: std_logic;
signal DONE_CURSOR: std_logic;


signal OP_SETCURSOR: std_logic;
signal XCOL: unsigned (7 downto 0);
signal YROW: unsigned (8 downto 0);
signal OP_DRAWCOLOUR: std_logic;
signal NUMPIX: unsigned (16 downto 0);
signal RGB: unsigned (15 downto 0);


begin -- comienzo de la arquitectura

-- Mapeamos las señales internas con las entradas salidas del módulo .
DUT: LCD_SINTEST port map (clk,reset_l,DONE_COLOUR,DONE_CURSOR,OP_SETCURSOR,XCOL,YROW,OP_DRAWCOLOUR,NUMPIX,RGB);
CLK<= not CLK after 10 ns; 

process
begin
reset_l<='0';
done_colour<='1';
done_cursor<='1';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';
wait for 20 ns; 


wait;



end process;


end arch_lcd_sintest_tb;

