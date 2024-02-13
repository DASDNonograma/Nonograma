-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definición entidad testbench: entidad vacía

entity nono_cursor_tb is

end nono_cursor_tb;

-- Definición arquitectura 
architecture arch_nono_cursor_tb of nono_cursor_tb is
-- Declaración del módulo que queremos testear con sus entradas y saidas
component nono_cursor is 
   port
      (
            clk,reset_l:  in std_logic;

            -- In
            COMMAND :    in std_logic_vector (2 downto 0);
            OUT_COMMAND: in std_logic;
            DONE_UPDATE: in std_logic;
            DONE_TOGGLE: in std_logic;
            NONO_INIT_DONE: in std_logic;
            -- Out
            CURSORX: out unsigned (3 downto 0);
            CURSORY: out unsigned (3 downto 0);
            UPDATE_CURSOR: out std_logic;
            TOGGLE_CURSOR: out std_logic;
            DONE_CMD: out std_logic
        
      );
end component;


-- Declaración de las señales que vamos conectar al módulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del módulo.
signal COMMAND: std_logic_vector (2 downto 0) := "000";
signal OUT_COMMAND: std_logic := '0';
signal DONE_UPDATE: std_logic := '0';
signal DONE_TOGGLE: std_logic := '0';
signal NONO_INIT_DONE: std_logic := '0';
-- out
signal CURSORX: unsigned (3 downto 0);
signal CURSORY: unsigned (3 downto 0);
signal UPDATE_CURSOR: std_logic;
signal TOGGLE_CURSOR: std_logic;
signal DONE_CMD: std_logic;



signal reset_l : std_logic:='1';
-- A la señal de reloj se le da un un valor inicial. Al resto de entradas del
-- módulo no es necesario, pero se puede hacer.

signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura

-- Mapeamos las señales internas con las entradas salidas del módulo .
DUT: nono_cursor port map
      (
            clk => CLK,
            reset_l => reset_l,
            COMMAND => COMMAND,
            OUT_COMMAND => OUT_COMMAND,
            DONE_UPDATE => DONE_UPDATE,
            DONE_TOGGLE => DONE_TOGGLE,
            NONO_INIT_DONE => NONO_INIT_DONE,
            CURSORX => CURSORX,
            CURSORY => CURSORY,
            UPDATE_CURSOR => UPDATE_CURSOR,
            TOGGLE_CURSOR => TOGGLE_CURSOR,
            DONE_CMD => DONE_CMD
      );

-- Definición de la señal de reloj mediante una asignación concurrente
CLK<= not CLK after 10 ns; 

-- en el testbench probamos lo siguiente: mover cursor en las cuatro direcciones (sin salirse de la cuadricula)
-- y comprobar que el cursor se mueve correctamente.
-- luego comprobamos los casos de borde, es decir, mover el cursor hacia arriba cuando ya esta en cursory=0 o hacia abajo cuando ya esta en cursory=15
-- y lo mismo para cursorx hacia la izquierda y derecha.
-- lo que deberiamos ver es que los contadores no hacen over o underflow y que se sigue enviado los msgs de update
-- luego probamos a enviar un comando de toggle.


-- 1. mover cursor hacia abajo
-- 2. mover cursor hacia arriba
-- 3. mover cursor hacia la derecha
-- 4. mover cursor hacia la izquierda
-- 5. enviar comando de toggle




process
begin


reset_l<='0';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';
wait for 40 ns; 
nono_init_done<='1';

-- 1. mover cursor hacia abajo
wait for 120 ns;
command<="001"; -- comando para mover cursor hacia abajo
OUT_COMMAND<='1';
wait for 20 ns;
OUT_COMMAND<='0';
wait for 120 ns;
done_update<='1';
wait for 20 ns;
assert (CURSORY= "0001") report "Error en mover cursor hacia abajo" severity error;
done_update<='0';
wait for 120 ns;
done_update<='1';
wait for 20 ns;
done_update<='0';

-- 2. mover cursor hacia arriba
wait for 120 ns;
command<="000"; -- comando para mover cursor hacia arriba
OUT_COMMAND<='1';
wait for 20 ns;
OUT_COMMAND<='0';
wait for 120 ns;
done_update<='1';
wait for 20 ns;
assert (CURSORY= "0000") report "Error en mover cursor hacia arriba" severity error;
done_update<='0';
wait for 120 ns;
done_update<='1';
wait for 20 ns;
done_update<='0';

-- 3. mover cursor hacia la derecha
wait for 120 ns;
command<="011"; -- comando para mover cursor hacia la derecha
OUT_COMMAND<='1';
wait for 20 ns;
OUT_COMMAND<='0';
wait for 120 ns;
done_update<='1';
wait for 20 ns;
assert (CURSORX= "0001") report "Error en mover cursor hacia la derecha" severity error;
done_update<='0';
wait for 120 ns;
done_update<='1';
wait for 20 ns;
done_update<='0';

-- 4. mover cursor hacia la izquierda
wait for 120 ns;
command<="010"; -- comando para mover cursor hacia la izquierda
OUT_COMMAND<='1';
wait for 20 ns;
OUT_COMMAND<='0';
wait for 120 ns;
done_update<='1';
wait for 20 ns;
assert (CURSORX= "0000") report "Error en mover cursor hacia la izquierda" severity error;
done_update<='0';
wait for 120 ns;
done_update<='1';
wait for 20 ns;
done_update<='0';

-- 5. enviar comando de toggle
wait for 120 ns;
command<="100"; -- comando para toggle cursor
OUT_COMMAND<='1';
wait for 20 ns;
OUT_COMMAND<='0';
wait for 120 ns;
done_toggle<='1';
wait for 20 ns;
done_toggle<='0';


wait;



end process;


end arch_nono_cursor_tb;

