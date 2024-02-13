-- Declaración librerias necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definicion entidad testbench: entidad vacía

entity cmd_process_tb is

end cmd_process_tb;

-- Definicion arquitectura 
architecture arch_cmd_process_tb of cmd_process_tb is
-- Declaracion del modulo que queremos testear con sus entradas y saidas
component cmd_process is 
   port
      (
      clk,reset_l:  in std_logic;

      -- In
      CHAR : unsigned(7 downto 0);
      CMD_PX_GO : in std_logic;
      DONE_CMD: in std_logic;
      DONE_BIT: in std_logic;
      
      -- Out
      COMMAND:  out std_logic_vector(2 downto 0);
      OUT_CMD:  out std_logic;
      INI_NONO: out  std_logic
      );
end component;


-- Declaracion de las seniales que vamos conectar al modulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del modulo.

signal CLK: std_logic:='0';
signal reset_l : std_logic:='1';

signal CMD_PX_GO : std_logic;
signal CHAR : unsigned(7 downto 0) := "00000000";
signal DONE_CMD: std_logic;
signal DONE_BIT: std_logic;


signal COMMAND: std_logic_vector(2 downto 0);
signal OUT_CMD: std_logic;
signal INI_NONO: std_logic;


-- A la senial de reloj se le da un un valor inicial. Al resto de entradas del
-- modulo no es necesario, pero se puede hacer.

begin -- comienzo de la arquitectura

-- Mapeamos las seniales internas con las entradas salidas del modulo .
DUT: cmd_process port map (
      clk => CLK,
      reset_l => reset_l,
      CHAR => CHAR,
      CMD_PX_GO => CMD_PX_GO,
      DONE_CMD => DONE_CMD,
      DONE_BIT => DONE_BIT,
      COMMAND => COMMAND,
      OUT_CMD => OUT_CMD,
      INI_NONO => INI_NONO
);

-- Definicion de la señal de reloj mediante una asignacion concurrente
CLK<= not CLK after 10 ns; 

-- Definicion de un proceso en el que vamos dando diferentes valores a las 
-- asignar valor 0 a las entradas del modulo




process
begin

-- Inicializacion de las entradas del modulo
CMD_PX_GO <= '0';
CHAR <= "01010100"; -- caracter T en ASCII
DONE_CMD <= '0';
DONE_BIT <= '0';

reset_l<='0';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';

-- Letra leida T, no deberia hacer nada
wait for 20 ns;
CMD_PX_GO <= '1';
wait for 20 ns;
CMD_PX_GO <= '0';
wait for 100 ns;



-- Empezando inicializacion, simulando que se ha enviado un fichero de nonograma, por lo tanto
-- recibe una i y luego 100 digitos de 0 o 1
CHAR <= "01101001"; -- i en ASCII
CMD_PX_GO <= '1';
wait for 20 ns;
CMD_PX_GO <= '0';
wait for 40 ns;

-- enviando 100 digitos de 0 o 1
for i in 0 to 49 loop
   CHAR <= "00110001"; -- 1 en ASCII
   CMD_PX_GO <= '1';
   wait for 20 ns;
   CMD_PX_GO <= '0';

   wait for 60 ns;
   done_bit <= '1';
   wait for 20 ns;
   done_bit <= '0';

end loop;

for i in 0 to 49 loop
      CHAR <= "00110000"; -- 0 en ASCII
      CMD_PX_GO <= '1';
      wait for 20 ns;
      CMD_PX_GO <= '0';
   
      wait for 60 ns;
      done_bit <= '1';
      wait for 20 ns;
      done_bit <= '0';
   
   end loop;
   


 -- ahora deberia de estar en modo nonograma




-- Modo nonograma, probando los comandos

-- caracter w en ASCII, tendria que salir que el commando es 000

CHAR <= "01110111"; -- w en ascii
CMD_PX_GO <= '1';
wait for 20 ns;
CMD_PX_GO <= '0';
wait for 40 ns;
DONE_CMD <= '1';
wait for 20 ns;
DONE_CMD <= '0';

wait for 200 ns;

-- caracter s en ASCII, tendria que salir que el commando es 001

CHAR <= "01110011"; -- s en ascii
CMD_PX_GO <= '1';
wait for 20 ns;
CMD_PX_GO <= '0';
wait for 40 ns;
DONE_CMD <= '1';
wait for 20 ns;
DONE_CMD <= '0';


wait for 200 ns;
-- caracter a en ASCII, tendria que salir que el commando es 010, CMD_OUT tiene que ser 1

CHAR <= "01100001"; -- a en ascii
CMD_PX_GO <= '1';
wait for 20 ns;
CMD_PX_GO <= '0';
wait for 40 ns;
DONE_CMD <= '1';
wait for 20 ns;
DONE_CMD <= '0';

wait for 200 ns;



-- caracter d en ASCII, tendria que salir que el commando es 011

CHAR <= "01100100"; -- d en ascii
CMD_PX_GO <= '1';
wait for 20 ns;
CMD_PX_GO <= '0';

wait for 40 ns;
DONE_CMD <= '1';
wait for 20 ns;
DONE_CMD <= '0';


wait for 200 ns;

-- caracter " " en ASCII, tendria que salir que el commando es 100
-- el espacio en ASCII es 00100000
CHAR <= "00100000"; -- espacio en ascii
CMD_PX_GO <= '1';
wait for 20 ns;
CMD_PX_GO <= '0';

wait for 40 ns;
DONE_CMD <= '1';
wait for 20 ns;
DONE_CMD <= '0';




wait for 200 ns;

-- caracter " " en ASCII, tendria que salir que el commando es 100
-- el espacio en ASCII es 00100000
CHAR <= "10101111"; -- espacio en ascii
CMD_PX_GO <= '1';
wait for 20 ns;
CMD_PX_GO <= '0';

wait for 40 ns;
DONE_CMD <= '1';
wait for 20 ns;
DONE_CMD <= '0';



wait;



end process;


end arch_cmd_process_tb;


