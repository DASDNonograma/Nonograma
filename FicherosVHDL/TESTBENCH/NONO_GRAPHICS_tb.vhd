<<<<<<< HEAD
-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nono_graphics_tb is

end nono_graphics_tb;

-- Definicion arquitectura
architecture arch_nono_graphics_tb of nono_graphics_tb is
-- Declaracion del modulo que queremos testear con sus entradas y saidas
component nono_graphics
    port(
        Clk,Reset_L: in std_logic;
        --IN
        OUT_CMD,DONE_DEL,DONE_FIG,UPDATE_CURSOR,TOGGLE_CURSOR,NONO_INI: in std_logic;
        COMMAND: in std_logic_vector(2 downto 0);
        CURSOR_POSX, CURSOR_POSY: in unsigned(3 downto 0);
        --OUT
        DRAW_TRIA,DRAW_CUAD,DRAW_LINE,DEL_SCREEN: out std_logic;
        DONE_UPDATE,DONE_CURSOR,NONO_init_DONE,DONE_BIT: out std_logic;
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
signal  DONE_UPDATE_tb,DONE_toggle_tb,NONO_init_DONE_tb,DONE_BIT_tb: std_logic :='0';


signal reset_l : std_logic:='1';
-- A la seinal de reloj se le da un un valor inicial. Al resto de entradas del
-- modulo no es necesario, pero se puede hacer.

signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura


-- Mapeamos las señales internas con las entradas salidas del modulo

DUT : NONO_GRAPHICS port map(
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
    DONE_CURSOR => DONE_toggle_tb,
    NONO_init_DONE => NONO_init_DONE_tb,
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

-- Definicion de la se�al de reloj mediante una asignacion concurrente
CLK<= not CLK after 10 ns; 

-- Definicion de un proceso en el que vamos dando diferentes valores a las 
-- se�ales de entrada del modulo a lo largo del tiempo. 
-- Uso de la sentencia "wait" para mantener los valores el tiempo necesario.

process
begin

reset_l<='0';
lcd_init_done_tb <= '1';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';
NONO_INI_tb <='1';
wait for 80 ns; 
NONO_INI_tb <='0';
-- Rellenar la pantalla de color negro, para ello, colorcode = 0 y activar DEL_SCREEN
OUT_CMD_tb <='1';
COMMAND_tb <=(others=>'1');
wait for 12 ms;
TOGGLE_CURSOR_tb <='1';
wait until done_toggle_tb ='1';
TOGGLE_CURSOR_tb <='0';
wait for 1 ms;
CURSOR_POSX_tb <=to_unsigned(0,4);
CURSOR_POSY_tb <=to_unsigned(0,4);
UPDATE_CURSOR_tb <='1';
wait until done_update_tb='1';
CURSOR_POSY_tb <=to_unsigned(1,4);
CURSOR_POSX_tb <=to_unsigned(1,4);
UPDATE_CURSOR_tb <='0';
wait;



end process;



=======
-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity nono_graphics_tb is

end nono_graphics_tb;

-- Definicion arquitectura
architecture arch_nono_graphics_tb of nono_graphics_tb is
-- Declaracion del modulo que queremos testear con sus entradas y saidas
component nono_graphics
    port(
        Clk,Reset_L: in std_logic;
        --IN
        OUT_CMD,DONE_DEL,DONE_FIG,UPDATE_CURSOR,TOGGLE_CURSOR,NONO_INI: in std_logic;
        COMMAND: in std_logic_vector(2 downto 0);
        CURSOR_POSX, CURSOR_POSY: in unsigned(3 downto 0);
        --OUT
        DRAW_TRIA,DRAW_CUAD,DRAW_LINE,DEL_SCREEN: out std_logic;
        DONE_UPDATE,DONE_CURSOR,NONO_init_DONE,DONE_BIT: out std_logic;
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
signal  DONE_UPDATE_tb,DONE_CURSOR_NONO_tb,NONO_init_DONE_tb,DONE_BIT_tb: std_logic :='0';


signal reset_l : std_logic:='1';
-- A la seinal de reloj se le da un un valor inicial. Al resto de entradas del
-- modulo no es necesario, pero se puede hacer.

signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura


-- Mapeamos las señales internas con las entradas salidas del modulo

DUT : NONO_GRAPHICS port map(
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
    DONE_CURSOR => DONE_CURSOR_NONO_tb,
    NONO_init_DONE => NONO_init_DONE_tb,
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

-- Definicion de la se�al de reloj mediante una asignacion concurrente
CLK<= not CLK after 10 ns; 

-- Definicion de un proceso en el que vamos dando diferentes valores a las 
-- se�ales de entrada del modulo a lo largo del tiempo. 
-- Uso de la sentencia "wait" para mantener los valores el tiempo necesario.

process
begin

reset_l<='0';
lcd_init_done_tb <= '1';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';
NONO_INI_tb <='1';
wait for 80 ns; 
NONO_INI_tb <='0';
-- Rellenar la pantalla de color negro, para ello, colorcode = 0 y activar DEL_SCREEN
OUT_CMD_tb <='1';
COMMAND_tb <=(others=>'1');
wait;



end process;



>>>>>>> 67242f6534ebe301c263ee35c3a91fa5e12e8ca0
end arch_nono_graphics_tb;