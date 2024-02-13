-- Declaración librerias necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definicion entidad testbench: entidad vacía

entity mod_uart_tb is

end mod_uart_tb;

-- Definicion arquitectura 
architecture arch_mod_uart_tb of mod_uart_tb is
-- Declaracion del modulo que queremos testear con sus entradas y saidas
component mod_uart is 
   port
      (
      clk,reset_l:  in std_logic;

      -- In
      RX : in std_logic;

      -- Out
      CMD_PX_GO : out std_logic;
      CHAR : out unsigned(7 downto 0)  
      );
end component;


-- Declaracion de las seniales que vamos conectar al modulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del modulo.

signal CLK: std_logic:='0';
signal reset_l : std_logic:='1';

signal RX : std_logic:='0';
signal CMD_PX_GO : std_logic;
signal CHAR : unsigned(7 downto 0);

-- A la senial de reloj se le da un un valor inicial. Al resto de entradas del
-- modulo no es necesario, pero se puede hacer.

begin -- comienzo de la arquitectura

-- Mapeamos las seniales internas con las entradas salidas del modulo .
DUT: mod_uart port map (
      clk => CLK,
      reset_l => reset_l,
      RX => RX,
      CMD_PX_GO => CMD_PX_GO,
      CHAR => CHAR
);

-- Definicion de la señal de reloj mediante una asignacion concurrente
CLK<= not CLK after 10 ns; 

-- Definicion de un proceso en el que vamos dando diferentes valores a las 
-- señales de entrada del modulo a lo largo del tiempo. 
-- Uso de la sentencia "wait" para mantener los valores el tiempo necesario.

process
begin

rx<='1';

reset_l<='0';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';

-- Simular la recepcion de un caracter "T" por el puerto serie a 76800 baudios
-- 1 bit cada 13.02 us
wait for 13.02 us; -- 1 start bit
rx<='0';

wait for 13.02 us; -- bit 0 (0) del caracter T en ASCII que es 74 en decimal y 0101 0100 en binario, bit menos significativo primero
rx<='0';
wait for 13.02 us; -- bit 1 (0) del caracter T
rx<='0';
wait for 13.02 us; -- bit 2 (1) del caracter T
rx<='1';
wait for 13.02 us; -- bit 3 (0) del caracter T
rx<='0';

wait for 13.02 us; -- bit 4 (1) del caracter T
rx<='1';
wait for 13.02 us; -- bit 5 (0) del caracter T
rx<='0';
wait for 13.02 us; -- bit 6 (1) del caracter T
rx<='1';
wait for 13.02 us; -- bit 7 (0) del caracter T
rx<='0';


wait for 13.02 us; -- bit end
rx <= '1';







wait;



end process;


end arch_mod_uart_tb;


