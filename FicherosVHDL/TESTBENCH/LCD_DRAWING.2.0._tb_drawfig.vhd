-- Declaración librerías necesarias
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Definicion entidad

entity lcd_drawing_tb is

end lcd_drawing_tb;

-- Definicion arquitectura 
architecture arch_lcd_drawing_tb_drawfig of lcd_drawing_tb is
-- Declaracion del modulo que queremos testear con sus entradas y saidas
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
signal LCD_init_done_tb, OP_SETCURSOR_tb, OP_DRAWCOLOUR_tb:   std_logic;
signal XCOL_tb:         unsigned ( 7 downto 0);
signal YROW_tb:         unsigned ( 8 downto 0);
signal RGB_tb:          unsigned ( 15 downto 0);
signal NUM_PIX_tb:      unsigned ( 16 downto 0);

signal DONE_CURSOR_tb, DONE_COLOUR_tb, LCD_CS_N_tb, LCD_WR_N_tb, LCD_RS_tb:   std_logic;
signal LCD_DATA_tb:                                               unsigned ( 15 downto 0);


-- Declaracion de la seinal de la entidad drawing
signal DEL_SCREEN_tb,DRAW_TRIA_tb,DRAW_CUAD_tb,DRAW_LINE_tb,VERTICAL_tb: std_logic := '0';
signal COLOUR_CODE_tb: unsigned(2 downto 0) := "000";
signal XCOR_tb : unsigned(7 downto 0) := X"00";
signal YCOR_tb : unsigned(8 downto 0) := '0' & X"00";
signal DONE_FIG_tb, DONE_DEL_tb :  std_logic :='0';


signal reset_l : std_logic:='1';
-- A la seinal de reloj se le da un un valor inicial. Al resto de entradas del
-- modulo no es necesario, pero se puede hacer.

signal CLK: std_logic:='0';

begin -- comienzo de la arquitectura

-- Mapeamos las señales internas con las entradas salidas del modulo

DUT : LCD_DRAWING port map (
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

-- Definicion de la señal de reloj mediante una asignacion concurrente
CLK<= not CLK after 10 ns; 

-- Definicion de un proceso en el que vamos dando diferentes valores a las 
-- señales de entrada del modulo a lo largo del tiempo. 
-- Uso de la sentencia "wait" para mantener los valores el tiempo necesario.

process
begin

reset_l<='0';
lcd_init_done_tb <= '1';
--asignaciones iniciales;
wait for 4 ns; -- introduciendo un retardo de 4 ns para no estar justo en el flanco de reloj
reset_l<='1';
wait for 20 ns; 
-- Rellenar la pantalla de color negro, para ello, colorcode = 0 y activar DEL_SCREEN
DRAW_LINE_tb<= '1';
COLOUR_CODE_tb <= "110";
XCOR_tb<=to_unsigned(100,8);
YCOR_tb<=to_unsigned(20,9);
VERTICAL_tb<='1';
wait for 20 ns; 
DRAW_LINE_tb <= '0';
wait for 1 us;
wait for 20 ns;
wait;



end process;


end arch_lcd_drawing_tb_drawfig;

