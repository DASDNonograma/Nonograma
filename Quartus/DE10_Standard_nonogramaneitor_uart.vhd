library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE10_Standard_nonogramaneitor_uart is
 port(
	-- CLOCK ----------------
	CLOCK_50	: in	std_logic;
--	CLOCK2_50	: in	std_logic;
--	CLOCK3_50	: in	std_logic;
--	CLOCK4_50	: in	std_logic;
	-- KEY ----------------
	KEY 		: in	std_logic_vector(2 downto 0);
--	KEY 		: in	std_logic_vector(3 downto 0);
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
	-- Touch --
-- LT24_ADC_PENIRQ_N	: in	std_logic;
-- LT24_ADC_DOUT		: in	std_logic;
-- LT24_ADC_BUSY		: in	std_logic;
-- LT24_ADC_DIN		: out	std_logic;
-- LT24_ADC_DCLK		: out	std_logic;
-- LT24_ADC_CS_N		: out	std_logic;
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
	-- HSMC default ------------------
-- HSMC_CLKIN0     	:in    	std_logic;
-- HSMC_CLKIN_N1   	:in    	std_logic;
-- HSMC_CLKIN_N2   	:in    	std_logic;
-- HSMC_CLKIN_P1   	:in    	std_logic;
-- HSMC_CLKIN_P2   	:in    	std_logic;
-- HSMC_CLKOUT0    	:out   	std_logic;
-- HSMC_CLKOUT_N1  	:out   	std_logic;
-- HSMC_CLKOUT_N2  	:out   	std_logic;
-- HSMC_CLKOUT_P1  	:out   	std_logic;
-- HSMC_CLKOUT_P2  	:out   	std_logic;
-- HSMC_D          	:inout 	std_logic_vector(3 downto 0);
-- HSMC_RX_D_N     	:inout 	std_logic_vector(16 downto 0);
-- HSMC_RX_D_P     	:inout 	std_logic_vector(16 downto 0);
-- HSMC_SCL        	:out   	std_logic;
-- HSMC_SDA        	:inout 	std_logic;
-- HSMC_TX_D_N     	:inout 	std_logic_vector(16 downto 0);
-- HSMC_TX_D_P     	:inout 	std_logic_vector(16 downto 0);
	-- IRDA ----------------
--	IRDA_RXD	: in	std_logic;
--	IRDA_TXD	: out	std_logic;
	-- PS2 ----------------
--	PS2_CLK		: in	std_logic;
--	PS2_CLK2	: in	std_logic;
--	PS2_DAT		: inout	std_logic;
--	PS2_DAT2	: inout	std_logic;
	-- Video-In ----------------
--	TD_CLK27	: in	std_logic;
--	TD_DATA		: in	std_logic_vector(7 downto 0);
--	TD_HS		: in	std_logic;
--	TD_RESET_N	: out	std_logic;
--	TD_VS		: in	std_logic;
	-- VGA ----------------
--	VGA_B		: out	std_logic_vector(7 downto 0);
--	VGA_BLANK_N	: out	std_logic;
--	VGA_CLK		: out	std_logic;
--	VGA_G		: out	std_logic_vector(7 downto 0);
--	VGA_HS		: out	std_logic;
--	VGA_R		: out	std_logic_vector(7 downto 0);
--	VGA_SYNC_N	: out	std_logic;
--	VGA_VS		: out	std_logic;	: out	std_logic
); -- ***OJO*** ultimo de la lista sin ;

end;

architecture rtl of DE10_Standard_nonogramaneitor_uart is 
	signal clk, reset_l   : std_logic;

	--- LCD_CTRL <-> LCD_DRAWING
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

--------------------------------------------------------------------
-- architecture body
--------------------------------------------------------------------
	
	
begin
	clk <= CLOCK_50;
	reset_l <= KEY(0);
  --DEL_SCREEN_local <= not (KEY(1));
  --DRAW_FIG_local <= not (KEY(2));
	
  del_screen_top <= nono_ini_top;
  -- draw_fig_local = '1' cuando el comando no es "111" y commandgo = '1'
  draw_cuad_top <= '1' when (command_top/= "111" and out_cmd_top = '1') else '0';
  nono_init_done_top <= '1';
  done_cmd_top <= '1';
  
  XCOR_top <= to_unsigned(37,8);
  YCOR_top <= to_unsigned(37,9);
	
-- portmaps
  
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
      RX => UART_RX,
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
  setup: LT24Setup port map (
	    -- CLOCK and Reset_l ----------------
      clk => clk,           
      reset_l => reset_l,       

      LT24_LCD_ON => '1',     
      LT24_RESET_N  => LT24_RESET_N,    
      LT24_CS_N => LT24_CS_N,       
      LT24_RS => LT24_RS,         
      LT24_WR_N => LT24_WR_N,       
      LT24_RD_N => LT24_RD_N,        
      LT24_D => LT24_D,           


      LT24_CS_N_Int => LCD_CS_N_top,        
      LT24_RS_Int => LCD_RS_top,          
      LT24_WR_N_Int => LCD_WR_N_top,        
      LT24_RD_N_Int => '1',        
      LT24_D_Int => std_logic_vector(LCD_DATA_top),           
      
      LT24_Init_Done=> LCD_init_done_top       
	);
  
  COLOUR_CODE_top <= unsigned(SW(2 downto 0));
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

end rtl;
