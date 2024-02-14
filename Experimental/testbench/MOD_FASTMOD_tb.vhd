-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--library ieee_proposed;


-- liberria para ufixed
--use ieee_proposed.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector
use ieee.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector
--use ieee.float_generic_pkg.all;	-- libreria para tipo float

-- Definición entidad testbench: entidad vacía

entity mod_fastmod_tb is

end mod_fastmod_tb;

-- Definición arquitectura 
architecture arch_mod_fastmod_tb of mod_fastmod_tb is
-- Declaración del módulo que queremos testear con sus entradas y saidas
component mod_fastmod is 
   port
      (
      clk,reset_l:  in std_logic;

      -- In 
      MOD_OP: in std_logic;
      inp: in sfixed (15 downto -16);
      -- OUT
      DONE_MOD_OP: out std_logic;
      result: out sfixed (5 downto -26)
      );
end component;

-- Declaración de las señales que vamos conectar al módulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del módulo.


signal reset_l : std_logic:='1';
signal CLK: std_logic:='0';

signal MOD_OP: std_logic:='0';
signal inp: sfixed (15 downto -16):= to_sfixed(12312.312,15,-16);
signal DONE_MOD_OP: std_logic;
signal result: sfixed (5 downto -26);




begin -- comienzo de la arquitectura

-- Mapeamos las señales internas con las entradas salidas del módulo .
DUT: mod_fastmod port map (clk,reset_l,MOD_OP,inp,DONE_MOD_OP,result);
CLK<= not CLK after 10 ns; 

process
begin
reset_l<='0';

--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';
wait for 20 ns; 
mod_op<='1';
wait for 20 ns;
mod_op<='0';


wait;



end process;


end arch_mod_fastmod_tb;

