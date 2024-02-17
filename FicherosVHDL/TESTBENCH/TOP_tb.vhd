-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definición entidad testbench: entidad vacía

entity top_tb is

end top_tb;

-- Definición arquitectura 
architecture arch_top_tb of top_tb is
-- Declaración del módulo que queremos testear con sus entradas y saidas

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
        DRAW_TRIA,DRAW_CUAD,DRAW_LINE,DEL_SCREEN,VERTICAL: out std_logic;
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



-- LCD_CTRL <-> LCD_DRAWING
signal LCD_init_done_top, OP_SETCURSOR_top, OP_DRAWCOLOUR_top:   std_logic;
signal XCOL_top:         unsigned ( 7 downto 0);
signal YROW_top:         unsigned ( 8 downto 0);
signal RGB_top:          unsigned ( 15 downto 0);
signal NUM_PIX_top:      unsigned ( 16 downto 0);

signal DONE_CURSOR_top, DONE_COLOUR_top, LCD_CS_N_top, LCD_WR_N_top, LCD_RS_top:   std_logic;
signal LCD_DATA_top:     unsigned ( 15 downto 0);  


signal RX_top: std_logic:= '0';
signal to_send: std_logic_vector(9 downto 0);


-- mod_uart <-> cmd_process
signal char_top: unsigned(7 downto 0);
signal cmd_px_go_top: std_logic;

-- cmd_process
signal COMMAND_top: std_logic_vector(2 downto 0);
signal OUT_CMD_top: std_logic;
-- cmd_process <-> nono_cursor
signal DONE_CMD_top: std_logic;
-- cmd_process <-> nono_graphics
signal NONO_INI_top: std_logic;
signal DONE_BIT_top: std_logic;

-- nono_cursor <-> nono_graphics
signal CURSOR_POSX_top, CURSOR_POSY_top: unsigned(3 downto 0);
signal UPDATE_CURSOR_top, TOGGLE_CURSOR_top: std_logic;
signal DONE_UPDATE_top, DONE_TOGGLE_top, NONO_init_DONE_top: std_logic;


-- nono_graphics <-> LCD_DRAWING
signal DEL_SCREEN_top: std_logic;
signal DRAW_TRIA_top, DRAW_CUAD_top, DRAW_LINE_top, VERTICAL_top: std_logic;
signal DONE_DEL_top, DONE_FIG_top: std_logic;
signal XCOR_top: unsigned(7 downto 0);
signal YCOR_top: unsigned(8 downto 0);
signal COLOUR_CODE_top: unsigned(2 downto 0);


signal reset_l : std_logic:='1';
-- A la señal de reloj se le da un un valor inicial. Al resto de entradas del
-- módulo no es necesario, pero se puede hacer.

signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura

-- mapeamos cada senial con su correspondiente entrada/salida del módulo
-- las seniales inexistentes se marcan como open


-- LCD_CTRL
ctrl: lcd_ctrl_Ent port map(
    clk => CLK,
    reset_l => reset_l,
    -- IN LT24 SETUP
    LCD_init_done => LCD_init_done_top,

    -- IN LCD_DRAWING
    OP_SETCURSOR => OP_SETCURSOR_top,
    OP_DRAWCOLOUR => OP_DRAWCOLOUR_top,
    XCOL => XCOL_top,
    YROW => YROW_top,
    RGB => RGB_top,
    NUM_PIX => NUM_PIX_top,

    -- OUT LCD_DRAWING
    DONE_CURSOR => DONE_CURSOR_top,
    DONE_COLOUR => DONE_COLOUR_top,

    -- OUT LT24 SETUP
    LCD_CS_N => LCD_CS_N_top,
    LCD_WR_N => LCD_WR_N_top,
    LCD_RS => LCD_RS_top,
    LCD_DATA => LCD_DATA_top
);

-- mod_uart
uart: mod_uart port map(
      clk => CLK,
      reset_l => reset_l,
      -- IN placa de desarrollo
      RX => rx_top,
      -- OUT cmd_process
      CMD_PX_GO => cmd_px_go_top,
      CHAR => char_top
);

-- cmd_process
process_cmd: cmd_process port map(
      clk => CLK,
      reset_l => reset_l,
      -- IN mod_uart
      CHAR => char_top,
      CMD_PX_GO => cmd_px_go_top,

      -- IN nono_cursor
      DONE_CMD => DONE_CMD_top,
      -- IN nono_graphics
      DONE_BIT => DONE_BIT_top,
      -- OUT nono_cursor and nono_graphics
      COMMAND => COMMAND_top,
      OUT_CMD => OUT_CMD_top,
      --OUT nono_graphics
      INI_NONO => NONO_INI_top
);


-- drawing
drawing: LCD_DRAWING port map(
      Clk => CLK,
      RESET_L => reset_l,
      -- IN NONO_GRAPHICS
      COLOUR_CODE => COLOUR_CODE_top,
      DEL_SCREEN => DEL_SCREEN_top,
      DRAW_TRIA => DRAW_TRIA_top,
      DRAW_CUAD => DRAW_CUAD_top,
      DRAW_LINE => DRAW_LINE_top,
      VERTICAL => VERTICAL_top,
      XCOR => XCOR_top,
      YCOR => YCOR_top,
      -- IN LCD_CTRL
      DONE_CURSOR => DONE_CURSOR_top,
      DONE_COLOUR => DONE_COLOUR_top,

      -- OUT LCD_CTRL
      OP_SETCURSOR => OP_SETCURSOR_top,
      OP_DRAWCOLOUR => OP_DRAWCOLOUR_top,
      DONE_FIG => DONE_FIG_top,
      DONE_DEL => DONE_DEL_top,
      XCOL => XCOL_top,
      YROW => YROW_top,
      RGB => RGB_top,
      NUM_PIX => NUM_PIX_top
);


-- nono_cursor
cursor: nono_cursor port map(
      clk => CLK,
      reset_l => reset_l,
      -- IN cmd_process
      COMMAND => COMMAND_top,
      OUT_COMMAND => OUT_CMD_top,
      -- IN nono_graphics
      DONE_UPDATE => DONE_UPDATE_top,
      DONE_TOGGLE => DONE_TOGGLE_top,
      NONO_INIT_DONE => NONO_init_DONE_top,
      -- OUT nono_graphics
      CURSORX => CURSOR_POSX_top,
      CURSORY => CURSOR_POSY_top,
      UPDATE_CURSOR => UPDATE_CURSOR_top,
      TOGGLE_CURSOR => TOGGLE_CURSOR_top,
      -- OUT cmd_process
      DONE_CMD => DONE_CMD_top
);

-- nono_graphics
graphics: nono_graphics port map(
      Clk => CLK,
      Reset_L => reset_l,
      -- IN CMD_PROCESS
      OUT_CMD => OUT_CMD_top,
      COMMAND => COMMAND_top,
      NONO_INI => NONO_INI_top,
      -- IN DRWAING
      DONE_DEL => DONE_DEL_top,
      DONE_FIG => DONE_FIG_top,
      -- IN nono_cursor
      UPDATE_CURSOR => UPDATE_CURSOR_top,
      TOGGLE_CURSOR => TOGGLE_CURSOR_top,
      CURSOR_POSX => CURSOR_POSX_top,
      CURSOR_POSY => CURSOR_POSY_top,

      -- OUT LCD_DRAWING
      DRAW_TRIA => DRAW_TRIA_top,
      DRAW_CUAD => DRAW_CUAD_top,
      DRAW_LINE => DRAW_LINE_top,
      DEL_SCREEN => DEL_SCREEN_top,
      VERTICAL => VERTICAL_top,
      XCOOR => XCOR_top,
      YCOOR => YCOR_top,
      COLOUR_CODE => COLOUR_CODE_top,
      -- OUT CURSOR
      DONE_UPDATE => DONE_UPDATE_top,
      DONE_TOGGLE => DONE_TOGGLE_top,
      NONO_init_DONE => NONO_init_DONE_top,
      -- OUT CMD_PROCESS
      DONE_BIT => DONE_BIT_top
      
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

rx_top<='1';
lcd_init_done_top<='1';
reset_l<='0';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';


-- simular mandar un caracter por uart, para ello modificar rx_top
-- primero el bit de stop, que es rx_top <= 0;
-- luego se envia el caracter ordenado con el bit de mayor peso primero
-- el bit de fin es rx_top <= 1;
-- se envian a 56700 baudios, asi que el tiempo entre bits es 17.36 us
-- mandar cualquier caracter, no deberia hacer nada
-- enviando letra "A", que es 0100_0001 en binario, asi que enviando bits(incluyendo bit de stop y fin) seria 0_1000_0010_1


-- for para enviar 10 bits, el primero y ultimo son el bit de stop y el bit de fin
-- el resto, los obtiene de la senial to_send, que es una interna
to_send <= "0100000101";
rx_top <= '1';

wait for 100 ns;

for i in 9 downto 0 loop
      rx_top <= to_send(i);
      wait for 17.36 us;
end loop;
-- enviando i ascii minuscula
to_send <= "0100101101";
rx_top <= '1';
for i in 9 downto 0 loop
      rx_top <= to_send(i);
      wait for 17.36 us;
end loop;

-- enviando 100 caracteres, que seran "0" y "1" alternados
for i in 0 to 49 loop
      -- 0 en ascii es 0011 0000, 1 en ascii es 00110001
      -- para enviarlo por uart, hay que invertirlo y poner un 0 al principio y un 1 al final
      -- de 00110000 pasa a 00001100 y luego se le aniaden el bit de stop y el bit de fin
      to_send <= "0000011001";
      for i in 9 downto 0 loop
            rx_top <= to_send(i);
            wait for 17.36 us;
      end loop;
      -- 1 en ascii es 001100001
      
      to_send <= "0100011001";
      for i in 9 downto 0 loop
            rx_top <= to_send(i);
            wait for 17.36 us;
      end loop;
end loop;






for k in 0 to 15 loop
      wait for 100 us;

      -- mover cursor hacia abajo, mandar s
      to_send <= "0110011101";
      for i in 9 downto 0 loop
            rx_top <= to_send(i);
            wait for 17.36 us;
      end loop;



      wait for 20 us;

      -- mover cursor hacia arriba, mandar w
      to_send <= "0111011101";
      for i in 9 downto 0 loop
            rx_top <= to_send(i);
            wait for 17.36 us;
      end loop;

      -- mandar " "
      to_send <= "0000001001";
      for i in 9 downto 0 loop
            rx_top <= to_send(i);
            wait for 17.36 us;
      end loop;

end loop;







wait;



end process;


end arch_top_tb;

