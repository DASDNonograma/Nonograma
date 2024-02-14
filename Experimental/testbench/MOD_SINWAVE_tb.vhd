-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector



-- Definición entidad testbench: entidad vacía

entity mod_sinwave_tb is

end mod_sinwave_tb;

-- Definición arquitectura 
architecture arch_mod_sinwave_tb of mod_sinwave_tb is
-- Declaración del módulo que queremos testear con sus entradas y saidas
component MOD_SINWAVE is 
   port
      (
            clk,reset_l:  in std_logic;

         
     -- In 
  ASK_OP: in std_logic;
  x: in sfixed (15 downto -16);
  -- OUT
  DONE_OP: out std_logic;
  result: out sfixed (5 downto -26)
      );
end component;

-- Declaración de las señales que vamos conectar al módulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del módulo.

signal ask_op: std_logic:='0';
signal x: sfixed (15 downto -16):= to_sfixed(23.5,15,-16);
signal done_op: std_logic;
signal result: sfixed (5 downto -26);


signal reset_l : std_logic:='1';
-- A la señal de reloj se le da un un valor inicial. Al resto de entradas del
-- módulo no es necesario, pero se puede hacer.

signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura

-- Mapeamos las señales internas con las entradas salidas del módulo .
DUT: MOD_SINWAVE port map (clk,reset_l,ask_op,x,done_op,result);

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
ask_op<='1';
wait for 20 ns;
ask_op<='0';


-- ir incrementando x en valores de 0.05 y solicitar operaciones
for i in 0 to 100 loop
x<=resize(x+to_sfixed(0.05,15,-16),x);
      wait for 20 ns;
      ask_op<='1';
      wait for 20 ns;
      ask_op<='0';
      wait for 1 us;
end loop;



wait;



end process;


end arch_mod_sinwave_tb;

