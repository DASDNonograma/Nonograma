library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DE10_Standard_nonogramaneitor is
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

architecture rtl of DE10_Standard_nonogramaneitor is 
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

  
  -- LCD_DRAWING
  signal COLOUR_CODE_local : unsigned(2 downto 0);
  signal DEL_SCREEN_local, DRAW_FIG_local : std_logic;

  -- CMD_PROCESS <-> MOD_UART
  signal CMD_PX_GO_local : std_logic;
  signal CHAR_local : unsigned(7 downto 0);

  -- CMD_PROCESS <-> this
  signal NONO_Init_Done_local : std_logic;
  signal DONE_CMD_local : std_logic;
  signal COMMAND_local : std_logic_vector(2 downto 0);
  signal OUT_CMD_local : std_logic;
  signal NONO_INI_local : std_logic;

  

component LCD_DRAWING  
port(
    Clk,RESET_L: in STD_LOGIC;
	 -- in
    COLOUR_CODE: in unsigned(2 downto 0);
    DEL_SCREEN,DRAW_FIG,DONE_CURSOR,DONE_COLOUR: in std_logic;
	 -- out
    OP_SETCURSOR,OP_DRAWCOLOUR: out STD_LOGIC;
    XCOL: out unsigned(7 downto 0);
    YROW: out unsigned(8 downto 0);
    RGB:out unsigned(15 downto 0);
    NUM_PIX: out unsigned(16 downto 0)
);
end component;

component mod_uart is
  port (
	clk,reset_l:  in std_logic;

  -- In
  RX : in std_logic;

  -- Out
  CMD_PX_GO : out std_logic;
  CHAR : out unsigned(7 downto 0)
  
  );
end component;

component cmd_process is
  port (
	clk,reset_l:  in std_logic;

  -- In
  CHAR : unsigned(7 downto 0);
  CMD_PX_GO : in std_logic;
  NONO_Init_Done : in std_logic;
  DONE_CMD: in std_logic;

  -- Out
  COMMAND:  out std_logic_vector(2 downto 0);
  OUT_CMD:  out std_logic;
  NONO_INI: out  std_logic
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
	
  del_screen_local <= nono_ini_local;
  -- draw_fig_local = '1' cuando el comando no es "111" y commandgo = '1'
  draw_fig_local <= '1' when (command_local /= "111" and out_cmd_local = '1') else '0';
  nono_init_done_local <= '1';
  done_cmd_local <= '1';
  
	
-- portmaps
  
-- portmap cmd_process
  cmd_proc: cmd_process port map (
    clk => clk,
    reset_l => reset_l,
  --in
    CHAR => CHAR_local,
    CMD_PX_GO => CMD_PX_GO_local,
    NONO_Init_Done => NONO_Init_Done_local,
    DONE_CMD => DONE_CMD_local,
  --out
    COMMAND => COMMAND_local,
    OUT_CMD => OUT_CMD_local,
    NONO_INI => NONO_INI_local
  );

  -- portmap mod_uart
  uart: mod_uart port map (
    clk => clk,
    reset_l => reset_l,

    RX => UART_RX,

    CMD_PX_GO => CMD_PX_GO_local,
    CHAR => CHAR_local
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
  
  COLOUR_CODE_local <= unsigned(SW(2 downto 0));
  drw: LCD_DRAWING port map(
      Clk         => clk,
      RESET_L     => reset_l,
    -- in
      COLOUR_CODE   => COLOUR_CODE_local,
      DEL_SCREEN    => DEL_SCREEN_local,
      DRAW_FIG      => DRAW_FIG_local,
      DONE_CURSOR   => DONE_CURSOR_local,
      DONE_COLOUR   => DONE_COLOUR_local,
    -- out
      OP_SETCURSOR  => OP_SETCURSOR_local,
      OP_DRAWCOLOUR => OP_DRAWCOLOUR_local,
      XCOL          => XCOL_local,
      YROW          => YROW_local,
      RGB           => RGB_local,
      NUM_PIX       => NUMPIX_local
);


end rtl;
