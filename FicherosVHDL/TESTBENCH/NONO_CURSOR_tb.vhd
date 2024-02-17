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

component nono_graphics
    port(
        Clk,Reset_L: in std_logic;
        --IN
        OUT_CMD,DONE_DEL,DONE_FIG,UPDATE_CURSOR,TOGGLE_CURSOR,NONO_INI: in std_logic;
        COMMAND: in std_logic_vector(2 downto 0);
        CURSOR_POSX, CURSOR_POSY: in unsigned(3 downto 0);
        --OUT
        DRAW_TRIA,DRAW_CUAD,DRAW_LINE,DEL_SCREEN: out std_logic;
        DONE_UPDATE,DONE_TOGGLE,NONO_init_DONE,DONE_BIT: out std_logic;
        XCOOR: out unsigned(7 downto 0);
        YCOOR: out unsigned(8 downto 0);
        COLOUR_CODE: out unsigned(2 downto 0) 
    );

end component;


component lcd_ctrl_Ent is 
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


component LCD_DRAWING is 
port(
    Clk,RESET_L : in STD_LOGIC;
    --IN
    COLOUR_CODE : in unsigned(2 downto 0);
    DEL_SCREEN,DRAW_TRIA,DONE_CURSOR,DONE_COLOUR,DRAW_CUAD,DRAW_LINE,VERTICAL : in std_logic;
    XCOR : in unsigned(7 downto 0);
    YCOR : in unsigned(8 downto 0);
    --OUT
    OP_SETCURSOR, OP_DRAWCOLOUR : out STD_LOGIC;
    DONE_FIG, DONE_DEL : out std_logic;
    XCOL : out unsigned(7 downto 0);
    YROW : out unsigned(8 downto 0);
    RGB : out unsigned(15 downto 0);
    NUM_PIX : out unsigned(16 downto 0)
);

end component;
-- Declaración de las señales que vamos conectar al módulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del módulo.

signal DONE_UPDATE: std_logic := '0';
signal DONE_TOGGLE: std_logic := '0';
signal NONO_INIT_DONE: std_logic := '0';
-- out
signal CURSORX: unsigned (3 downto 0);
signal CURSORY: unsigned (3 downto 0);
signal UPDATE_CURSOR: std_logic;
signal TOGGLE_CURSOR: std_logic;
signal DONE_CMD: std_logic;















-- Declaracion de las señales que vamos conectar al modulo.
-- Normalmente les damos el mismo nombre que a las entradas/salidas del modulo.
--Seinales de la entidad lcd_ctrl_ent
signal LCD_init_done_tb, OP_SETCURSOR_tb, OP_DRAWCOLOUR_tb:   std_logic;
signal XCOL_tb:         unsigned ( 7 downto 0);
signal YROW_tb:         unsigned ( 8 downto 0);
signal RGB_tb:          unsigned ( 15 downto 0);
signal NUM_PIX_tb:      unsigned ( 16 downto 0);

signal DONE_CURSOR_tb, DONE_COLOUR_tb, LCD_CS_N_tb, LCD_WR_N_tb, LCD_RS_tb:   std_logic;
signal LCD_DATA_tb:     unsigned ( 15 downto 0);  


-- Declaracion de la seinal de la entidad drawing
signal DEL_SCREEN_tb,DRAW_TRIA_tb,DRAW_CUAD_tb,DRAW_LINE_tb,VERTICAL_tb: std_logic := '0';
signal COLOUR_CODE_tb: unsigned(2 downto 0) := "000";
signal XCOR_tb : unsigned(7 downto 0) := X"00";
signal YCOR_tb : unsigned(8 downto 0) := '0' & X"00";
signal DONE_FIG_tb, DONE_DEL_tb :  std_logic :='0';


-- Declaracion de la seinal de la entidad nono graphics
signal OUT_CMD_tb,UPDATE_CURSOR_tb,TOGGLE_CURSOR_tb,NONO_INI_tb:  std_logic :='0';
signal COMMAND_tb: std_logic_vector(2 downto 0):= "000";
signal CURSOR_POSX_tb, CURSOR_POSY_tb: unsigned(3 downto 0) :=X"0";
signal  DONE_UPDATE_tb,DONE_TOGGLE_tb,NONO_init_DONE_tb,DONE_BIT_tb: std_logic :='0';


















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
            COMMAND => COMMAND_tb,
            OUT_COMMAND => OUT_CMD_tb,
            DONE_UPDATE => DONE_UPDATE_tb,
            DONE_TOGGLE => DONE_TOGGLE_TB,
            NONO_INIT_DONE => NONO_INIT_DONE,

            -- nono_gfx <-> cursor
            CURSORX => CURSOR_POSX_tb,
            CURSORY => CURSOR_POSY_tb,
            UPDATE_CURSOR => UPDATE_CURSOR_tb,
            TOGGLE_CURSOR => TOGGLE_CURSOR_tb,
            -- nono_cursor -> cmd_process
            DONE_CMD => DONE_CMD
      );



graph : NONO_GRAPHICS port map(
    Clk => Clk,
    Reset_L => Reset_L,
    OUT_CMD => OUT_CMD_tb,
    DONE_DEL => DONE_DEL_tb,
    DONE_FIG => DONE_FIG_tb,

    UPDATE_CURSOR => UPDATE_CURSOR_tb,
    TOGGLE_CURSOR => TOGGLE_CURSOR_tb,
    NONO_INI => NONO_INI_tb,


    COMMAND => COMMAND_tb,

    CURSOR_POSX => CURSOR_POSX_tb, 
    CURSOR_POSY => CURSOR_POSY_tb,

    DRAW_TRIA => DRAW_TRIA_tb,
    DRAW_CUAD => DRAW_CUAD_tb,
    DRAW_LINE => DRAW_LINE_tb, 
    DEL_SCREEN =>DEL_SCREEN_tb,
    DONE_UPDATE => DONE_UPDATE_tb,
    DONE_TOGGLE => DONE_TOGGLE_TB,
    NONO_init_DONE => NONO_INIT_DONE,
    DONE_BIT => DONE_BIT_tb,
    XCOOR => XCOR_tb,
    YCOOR => YCOR_tb,
    COLOUR_CODE => COLOUR_CODE_tb
);


drawing : LCD_DRAWING port map (
      Clk => CLK,
      RESET_L => reset_l,
      COLOUR_CODE => COLOUR_CODE_tb,
      DEL_SCREEN => DEL_SCREEN_tb,
      DRAW_TRIA => DRAW_TRIA_tb,
      DONE_CURSOR => DONE_CURSOR_tb,
      DONE_COLOUR => DONE_COLOUR_tb,
      OP_SETCURSOR => OP_SETCURSOR_tb,
      OP_DRAWCOLOUR => OP_DRAWCOLOUR_tb,
      XCOL => XCOL_tb,
      YROW => YROW_tb,
      RGB => RGB_tb,
      NUM_PIX => NUM_PIX_tb,
      DRAW_CUAD => DRAW_CUAD_tb,
      DRAW_LINE => DRAW_LINE_tb,
      VERTICAL => VERTICAL_tb,
      YCOR => YCOR_tb,
      XCOR => XCOR_tb,
      DONE_DEL => DONE_DEL_tb,
      DONE_FIG => DONE_FIG_tb
);


ctrl: lcd_ctrl_ent port map (
      clk => CLK,
      reset_l => reset_l,
      LCD_init_done => LCD_init_done_tb,
      OP_SETCURSOR => OP_SETCURSOR_tb,
      OP_DRAWCOLOUR => OP_DRAWCOLOUR_tb,
      XCOL => XCOL_tb,
      YROW => YROW_tb,
      RGB => RGB_tb,
      NUM_PIX => NUM_PIX_tb,
      DONE_CURSOR => DONE_CURSOR_tb,
      DONE_COLOUR => DONE_COLOUR_tb,
      LCD_CS_N => LCD_CS_N_tb,
      LCD_WR_N => LCD_WR_N_tb,
      LCD_RS => LCD_RS_tb,
      LCD_DATA => LCD_DATA_tb
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
NONO_INI_tb <='1';
lcd_init_done_tb <= '1';
--
OUT_CMD_tb <='1';
COMMAND_tb <=(others=>'1');


wait for 10 ms;
OUT_CMD_tb <='0';


wait for 3 ms;
wait for 40 ns; 


-- 1. mover cursor hacia abajo
wait for 120 ns;
command_tb<="001"; -- comando para mover cursor hacia abajo
OUT_CMD_tb<='1';
wait for 20 ns;
OUT_CMD_tb<='0';

wait until DONE_update_tb = '1';
wait for 40 ns;
wait until DONE_update_tb = '1';


wait for 10 us;
assert (CURSORY= "0001") report "Error en mover cursor hacia abajo" severity error;


-- 2. mover cursor hacia arriba
wait for 120 ns;
command_tb<="000"; -- comando para mover cursor hacia arriba
OUT_CMD_tb<='1';
wait for 20 ns;
OUT_CMD_tb<='0';

wait until done_update_tb = '1';
wait for 40 ns;
wait until DONE_update_tb = '1';
wait for 20 us;
assert (CURSORY= "0000") report "Error en mover cursor hacia arriba" severity error;


-- 3. mover cursor hacia la derecha
wait for 120 ns;
command_tb<="011"; -- comando para mover cursor hacia la derecha
OUT_CMD_tb<='1';
wait for 20 ns;
OUT_CMD_tb<='0';

wait until done_update_tb = '1';
wait for 40 ns;
wait until DONE_update_tb = '1';


wait for 20 us;
assert (CURSORX= "0001") report "Error en mover cursor hacia la derecha" severity error;




-- 4. mover cursor hacia la izquierda
wait for 120 ns;
command_tb<="010"; -- comando para mover cursor hacia la izquierda
OUT_CMD_tb<='1';
wait for 20 ns;
OUT_CMD_tb<='0';

wait until done_update_tb = '1';
wait for 40 ns;
wait until DONE_update_tb = '1';


wait for 20 us;
assert (CURSORX= "0000") report "Error en mover cursor hacia la izquierda" severity error;


-- 5. enviar comando de toggle
wait for 120 ns;
command_tb<="100"; -- comando para toggle cursor
OUT_CMD_tb<='1';
wait for 20 ns;
OUT_CMD_tb<='0';


wait;



end process;


end arch_nono_cursor_tb;

