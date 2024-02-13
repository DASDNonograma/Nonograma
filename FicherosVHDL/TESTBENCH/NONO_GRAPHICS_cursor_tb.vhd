-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definición entidad testbench: entidad vacía

entity nono_graphics_cursor_tb is

end nono_graphics_cursor_tb;

-- Definición arquitectura 
architecture arch_nono_graphics_cursor_tb of nono_graphics_cursor_tb is
-- Declaración del módulo que queremos testear con sus entradas y saidas
component nono_graphics_cursor is 
   port
      (
            clk,reset_l:  in std_logic;

          -- In
            UPDATE_CURSOR, TOGGLE_CURSOR, DONE_FIG: in std_logic;
            sol_out: in std_logic;
            cursorx, cursory: in unsigned (3 downto 0);
            -- Out
            XCOOR_int : out unsigned (7 downto 0);
            YCOOR_int : out unsigned (8 downto 0);
            DRAW_CUAD_int, DRAW_TRIA_int: out std_logic;
            DONE_UPDATE, DONE_TOGGLE: out std_logic;
            addr_int: out unsigned (6 downto 0);
            rd_sol: out std_logic
  

        
      );
end component;


-- Declaración de las señales que vamos conectar al módulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del módulo.

signal update_cursor, toggle_cursor, done_fig: std_logic;
signal sol_out: std_logic;


signal CURSORX: unsigned (3 downto 0);
signal CURSORY: unsigned (3 downto 0);
signal DRAW_CUAD, DRAW_TRIA: std_logic;
signal DONE_UPDATE, DONE_TOGGLE: std_logic;

signal xcoor: unsigned (7 downto 0);
signal ycoor: unsigned (8 downto 0);

signal addr: unsigned (6 downto 0);
signal rd: std_logic;
signal sol: std_logic;


signal reset_l : std_logic:='1';
-- A la señal de reloj se le da un un valor inicial. Al resto de entradas del
-- módulo no es necesario, pero se puede hacer.

signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura

-- Mapeamos las señales internas con las entradas salidas del módulo .
DUT: nono_graphics_cursor port map
      (
            clk => CLK,
            reset_l => reset_l,
           
            UPDATE_CURSOR => update_cursor,
            TOGGLE_CURSOR => toggle_cursor,
            DONE_FIG => done_fig,
            sol_out => sol_out,
            cursorx => CURSORX,
            cursory => CURSORY,


            XCOOR_int => xcoor,
            YCOOR_int => ycoor,
            DRAW_CUAD_int => DRAW_CUAD,
            DRAW_TRIA_int => DRAW_TRIA,
            DONE_UPDATE => DONE_UPDATE,
            DONE_TOGGLE => DONE_TOGGLE,
            addr_int => addr,
            rd_sol => rd

      );

-- Definición de la señal de reloj mediante una asignación concurrente
CLK<= not CLK after 10 ns; 
-- En el testbench vamos a probar lo siguiente:


-- Test 1:
-- Cursor en 0,0, hacer toggle
-- Observar que cambia el valor del mapa de la ram

-- Test 2:
-- Simular que se esta moviendo el cursor de 0,0 a 0,1
-- Para ello, hacer un done_update, y luego actualiza el valor de cursorx e y
-- mandar otro update_cursor y observar señales

-- Test 3:
-- Simular que se esta moviendo el cursor de 0,1 a 1,1
-- Para ello, hacer un done_update, y luego actualiza el valor de cursorx e y
-- mandar otro update_cursor y observar señales

-- Test 4: Condicion de victoria
-- Cursor en 0,1 y hacer toggle. Observar que se enciende la señal de victoria






process
begin

update_cursor<='0';
toggle_cursor<='0';
done_fig<='0';
sol_out<='0';
cursorx<="0000";
cursory<="0000";



reset_l<='0';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';
wait for 40 ns; 

-- Test 1
update_cursor<='0';
toggle_cursor<='1';
done_fig<='1';
sol_out<='0';


wait for 100 ns;
-- assert de las coordenadas
--assert (CURSORX= "0000") report "Error en mover cursor hacia la izquierda" severity error;


-- wait until 6300ns
wait until done_toggle='1';
toggle_cursor<='0';

wait for 24 ns;
wait for 200 ns;





-- Test 2, mover cursor de 0,0 a 0,1
cursorx<="0000";
cursory<="0000";
update_cursor<='1';

wait until done_update='1';
update_cursor<='0';
cursory<="0001";



wait until done_update='1';

assert (xcoor = to_unsigned(23,8)) report "Error en mover cursor hacia abajo" severity error;
assert (ycoor = to_unsigned(17+21,9)) report "Error en mover cursor hacia abajo" severity error;




-- Test 3, mover cursor de 0,1 a 1,1
cursorx<="0000";
cursory<="0001";
update_cursor<='1';

wait until done_update='1';
update_cursor<='0';
cursorx<="0001";


wait until done_update='1';
wait for 100 ns;
assert (xcoor = to_unsigned(23+21,8)) report "Error en mover cursor hacia abajo" severity error;
assert (ycoor = to_unsigned(17+21,9)) report "Error en mover cursor hacia abajo" severity error;


-- Test 4, condicion de victoria
-- para ello mandar toggle_cursor en 1,1
toggle_cursor<='1';

-- for de 100, mandar por sol_out un valor de 1 para las direcciones 0 y 11, el resto 0
for i in -1 to 99 loop
  if i=0 or i=11 then
    sol_out<='1';
  else
    sol_out<='0';
  end if;
  wait until rd='1';
end loop;

wait until done_toggle='1';
toggle_cursor<='0';







wait;



end process;


end arch_nono_graphics_cursor_tb;

