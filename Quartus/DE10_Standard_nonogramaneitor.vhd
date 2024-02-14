library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE10_Standard_nonogramaneitor is
 port(
	-- CLOCK ----------------
	CLOCK_50	: in	std_logic;
	-- KEY ----------------
	KEY 		: in	std_logic_vector(3 downto 0);
	-- LEDR ----------------
--	LEDR 		: out	std_logic_vector(9 downto 0);
	-- SW ----------------
	SW 			: in	std_logic_vector(9 downto 0);
	-- GPIO-LT24-UART ----------
	-- LCD --
   LT24_LCD_ON 	: out	std_logic;
   LT24_RESET_N	: out	std_logic;
   LT24_CS_N		: out	std_logic;
   LT24_RD_N		: out	std_logic;
   LT24_RS			: out	std_logic;
   LT24_WR_N		: out	std_logic;
   LT24_D			: out	std_logic_vector(15 downto 0);

	-- UART --
	UART_RX		: in	std_logic
	-- GPIO default ----------------
--	GPIO 		: inout	std_logic_vector(35 downto 0);
	-- CODEC Audio ----------------
--	AUD_ADCDAT	: in	std_logic;
--	AUD_ADCLRCK	: in	std_logic;
--	AUD_BCLK	: in	std_logic;
--	AUD_DACDAT	: out	std_logic;
--	AUD_DACLRCK	: in	std_logic;
--	AUD_XCK		: out	std_logic;
	-- I2C for Audio and Video-In ----------------
--	FPGA_I2C_SCLK	: out	std_logic;
--	FPGA_I2C_SDAT	: inout	std_logic;
	-- SDRAM ----------------
--	DRAM_ADDR	: out	std_logic_vector(12 downto 0);
--	DRAM_BA		: out	std_logic_vector(1 downto 0);
--	DRAM_CAS_N	: out	std_logic;
--	DRAM_CKE	: out	std_logic;
--	DRAM_CLK	: out	std_logic;
--	DRAM_CS_N	: out	std_logic;
--	DRAM_DQ		: inout	std_logic_vector(15 downto 0);
--	DRAM_LDQM	: out	std_logic;
--	DRAM_RAS_N	: out	std_logic;
--	DRAM_UDQM	: out	std_logic;
--	DRAM_WE_N	: out	std_logic;
	-- 7-SEG ----------------
--	HEX0	: out	std_logic_vector(6 downto 0);
--	HEX1	: out	std_logic_vector(6 downto 0);
--	HEX2	: out	std_logic_vector(6 downto 0);
--	HEX3	: out	std_logic_vector(6 downto 0);
--	HEX4	: out	std_logic_vector(6 downto 0);
--	HEX5	: out	std_logic_vector(6 downto 0);
	-- ADC ----------------
--	ADC_CS_N	: out	std_logic;
--	ADC_DIN		: out	std_logic;
--	ADC_DOUT	: in	std_logic;
--	ADC_SCLK	: out	std_logic;

	-- PS2 ----------------
--	PS2_CLK		: in	std_logic;
--	PS2_CLK2	: in	std_logic;
--	PS2_DAT		: inout	std_logic;
--	PS2_DAT2	: inout	std_logic;
); -- ***OJO*** ultimo de la lista sin ;

end;

architecture rtl of DE10_Standard_nonogramaneitor is 










component NONO_GFX is
  port (
	clk,reset_l:  in std_logic;

  -- in
  CMD_PX_GO: in std_logic;
  INI_NONO: in std_logic;
  COMMAND: in std_logic_vector(2 downto 0);
  CURSORX, CURSORY: in unsigned(3 downto 0);
  UPDATE_CURSOR, TOGGLE_CURSOR: in std_logic;
  DONE_FIG, DONE_DEL: in std_logic;

  -- OUT

  XCOOR:        out unsigned(7 downto 0);
  YCOOR:        out unsigned(8 downto 0);
  COLOUR_CODE:  out unsigned(2 downto 0);
  DRAW_CUAD, DRAW_TRIA, DRAW_LINE, VERTICAL: out std_logic;
  DEL_SCREEN:   out std_logic;
  DONE_UPDATE, DONE_TOGGLE: out std_logic
 
  );
end component;


component LCD_DRAWING  
port(
    Clk,RESET_L: in STD_LOGIC;
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

	
component lcd_ctrl_ent 
  port (
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


component LT24Setup
 port(
      -- CLOCK and Reset_l ----------------
      clk            : in      std_logic;
      reset_l        : in      std_logic;

      LT24_LCD_ON      : out std_logic;
      LT24_RESET_N     : out std_logic;
      LT24_CS_N        : out std_logic;
      LT24_RS          : out std_logic;
      LT24_WR_N        : out std_logic;
      LT24_RD_N        : out std_logic;
      LT24_D           : out std_logic_vector(15 downto 0);

      LT24_CS_N_Int        : in std_logic;
      LT24_RS_Int          : in std_logic;
      LT24_WR_N_Int        : in std_logic;
      LT24_RD_N_Int        : in std_logic;
      LT24_D_Int           : in std_logic_vector(15 downto 0);
      
      LT24_Init_Done       : out std_logic
 );
end component;






	signal clk, reset_l   : std_logic;

		
	-- LCD_SETUP <-> LCD_CTRL
  signal d: unsigned (15 downto 0);
	signal cs_n, wr_n, rs, init_done : std_logic;
	

  -- LCD_CTRL <-> LCD_DRAWING
  signal OP_SETCURSOR_local, OP_DRAWCOLOUR_local : std_logic;
  signal DONE_COLOUR_local, DONE_CURSOR_local: std_logic;
	signal rgb_local : unsigned (15 downto 0);
  signal xcol_local : unsigned (7 downto 0);
  signal yrow_local :unsigned (8 downto 0);
  signal numpix_local : unsigned (16 downto 0);

  
  -- LCD_DRAWING <-> NONO_GFX
  signal DEL_SCREEN_local, draw_cuad_local, draw_tria_local, draw_line_local, vertical_local: std_logic;
  signal xcor_local: unsigned (7 downto 0);
  signal ycor_local: unsigned (8 downto 0);
  signal COLOUR_CODE_local: unsigned (2 downto 0);
  signal done_fig_local, done_del_local: std_logic;


  -- nono_gfx -> this
  signal nono_ini_local: std_logic;
  signal command_local: std_logic_vector(2 downto 0);
  signal cursorx_local, cursory_local: unsigned(3 downto 0);
  signal update_cursor_local, toggle_cursor_local: std_logic;

  signal done_update_local, done_toggle_local: std_logic;
  

  


--------------------------------------------------------------------
-- architecture body
--------------------------------------------------------------------
	
	
begin
	clk <= CLOCK_50;
	reset_l <= KEY(0);
	
  -- nono_gfx -> this
	command_local <= "000";
  cursorx_local <= unsigned(SW(3 downto 0));
  cursory_local <= unsigned(SW(7 downto 4));
  nono_ini_local <= KEY(1);
  update_cursor_local <= KEY(2);
  toggle_cursor_local <= KEY(3);


-- portmaps

gfx: NONO_GFX port map(
  clk => clk,
  reset_l => reset_l,
  CMD_PX_GO => '0',
  INI_NONO => nono_ini_local,
  COMMAND => command_local,
  CURSORX => cursorx_local,
  CURSORY => cursory_local,
  UPDATE_CURSOR => update_cursor_local,
  TOGGLE_CURSOR => toggle_cursor_local,
  DONE_FIG => done_fig_local,
  DONE_DEL => done_del_local,

  XCOOR => xcor_local,
  YCOOR => ycor_local,
  COLOUR_CODE => COLOUR_CODE_local,
  DRAW_CUAD => draw_cuad_local,
  DRAW_TRIA => draw_tria_local,
  DRAW_LINE => draw_line_local,
  VERTICAL => vertical_local,
  DEL_SCREEN => del_screen_local,
  DONE_UPDATE => done_update_local,
  DONE_TOGGLE => done_toggle_local
);


draw: LCD_DRAWING port map(
  Clk => clk,
  RESET_L => reset_l,

  COLOUR_CODE => COLOUR_CODE_local,
  DEL_SCREEN => DEL_SCREEN_local,
  DRAW_TRIA => DRAW_TRIA_local,
  DONE_CURSOR => DONE_CURSOR_local,
  DONE_COLOUR => DONE_COLOUR_local,
  DRAW_CUAD => DRAW_CUAD_local,
  DRAW_LINE => DRAW_LINE_local,
  VERTICAL => VERTICAL_local,
  XCOR => xcor_local,
  YCOR => ycor_local,

  OP_SETCURSOR => OP_SETCURSOR_local,
  OP_DRAWCOLOUR => OP_DRAWCOLOUR_local,
  DONE_FIG => done_fig_local,
  DONE_DEL => done_del_local,
  XCOL => xcol_local,
  YROW => yrow_local,
  RGB => rgb_local,
  NUM_PIX => numpix_local
);
  


 

  setup: LT24Setup port map (
	    -- CLOCK and Reset_l ----------------
      clk => clk,           
      reset_l => reset_l,       

      LT24_LCD_ON => LT24_LCD_ON,     
      LT24_RESET_N  => LT24_RESET_N,    
      LT24_CS_N => LT24_CS_N,       
      LT24_RS => LT24_RS,         
      LT24_WR_N => LT24_WR_N,       
      LT24_RD_N => LT24_RD_N,        
      LT24_D => LT24_D,           


      LT24_CS_N_Int => cs_n,        
      LT24_RS_Int => rs,          
      LT24_WR_N_Int => wr_n,        
      LT24_RD_N_Int => '1',        
      LT24_D_Int => std_logic_vector(d),           
      
      LT24_Init_Done=> init_done       
	);
  
  ctrl: lcd_ctrl_ent port map(
    clk           => clk,
    reset_l         => reset_l,

    -- In
    LCD_init_done => init_done,
    OP_SETCURSOR  => OP_SETCURSOR_local,
    OP_DRAWCOLOUR => OP_DRAWCOLOUR_local,
    XCOL          => xcol_local,
    YROW          => yrow_local,
    RGB           => rgb_local,
    NUM_PIX       => numpix_local,
    
    -- Out
    DONE_CURSOR => DONE_CURSOR_local,
    DONE_COLOUR => DONE_COLOUR_local,
    
    LCD_CS_N      => cs_n,
    LCD_WR_N      => wr_n,
    LCD_RS        => rs,
    LCD_DATA      => d
	
  );
  
  


end rtl;
