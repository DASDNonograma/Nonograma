-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definición entidad testbench: entidad vacía

entity mod_fourier_tb is

end mod_fourier_tb;

-- Definición arquitectura 
architecture arch_mod_fourier_tb of mod_fourier_tb is
-- Declaración del módulo que queremos testear con sus entradas y saidas
component mod_fourier_ent is 
   port
      (
            clk,reset_l:  in std_logic;

            input_a : in std_logic_vector (15 downto 0);
            input_b : in std_logic_vector (15 downto 0);
            output_div : out std_logic_vector (15 downto 0);
            output_divzeroerror : out std_logic
      );
end component;

-- Declaración de las señales que vamos conectar al módulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del módulo.

signal input_a : std_logic_vector (15 downto 0);
signal input_b : std_logic_vector (15 downto 0);
signal output_div : std_logic_vector (15 downto 0);
signal output_divzeroerror : std_logic;


signal reset_l : std_logic:='1';
-- A la señal de reloj se le da un un valor inicial. Al resto de entradas del
-- módulo no es necesario, pero se puede hacer.

signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura

-- Mapeamos las señales internas con las entradas salidas del módulo .
DUT: mod_fourier_ent port map (clk,reset_l,input_a,input_b,output_div,output_divzeroerror);

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


wait;



end process;


end arch_mod_fourier_tb;

