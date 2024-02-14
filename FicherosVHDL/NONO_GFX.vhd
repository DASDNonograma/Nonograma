-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed

-- Declaracion entidad
entity NONO_GFX is
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
end NONO_GFX;


architecture NONO_GFX_arch of NONO_GFX is

  
  component SUBMOD_RAM is
    port(
        clk: in std_logic; -- Clock input
        reset_l: in std_logic; -- Reset input
    
        addr: in unsigned(6 downto 0); -- Address to write/read RAM
        data_in: in std_logic; -- Data to write into RAM
        WR: in std_logic; -- Write enable 
        RD: in std_logic; -- Read enable 
     
      data_out: out std_logic -- Data output of RAM
    );
    end component;



  component NONO_GRAPHICS_grid is
    port (
    clk,reset_l:  in std_logic;
  
    -- In
    GRID_OP:  in std_logic;
    DONE_DEL: in std_logic;
    DONE_FIG: in std_logic;
  
    -- Out
    
      XCOOR:        out unsigned(7 downto 0);
      YCOOR:        out unsigned(8 downto 0);
      COLOUR_CODE:  out unsigned(2 downto 0);
      DONE_GRID:    out std_logic;
      DEL_SCREEN:   out std_logic;
      DRAW_CUAD:    out std_logic;
      DRAW_TRIA:    out std_logic;
      DRAW_LINE, VERTICAL: out std_logic
      
  
    );
  end component;
  

  component nono_graphics_cursor is
    port (
    clk,reset_l:  in std_logic;
  
    -- In
    UPDATE_CURSOR, TOGGLE_CURSOR, DONE_FIG: in std_logic;
    sol_out: in std_logic;
    cursorx, cursory: in unsigned (3 downto 0);
    -- Out
    XCOOR_int : out unsigned (7 downto 0);
    YCOOR_int : out unsigned (8 downto 0);
    COLOUR_CODE_int: out unsigned (2 downto 0);
    DRAW_CUAD_int, DRAW_TRIA_int: out std_logic;
    DONE_UPDATE, DONE_TOGGLE: out std_logic;
    addr_int: out unsigned (6 downto 0);
    rd_sol: out std_logic
    
  
  
    
    );
  end component;




  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_W8_INI_NONO, E_GRID_BUILDING, E_SLAVE_MODE_START, E_SLAVE);
  -- UC
  signal epres,esig: tipo_estado;
  
  signal rslave: std_logic; signal pr_slave: std_logic;
  
  -- seniales multiplexadas
  signal xcoor_int: unsigned(7 downto 0);
  signal ycoor_int: unsigned(8 downto 0);
  signal colour_code_int: unsigned(2 downto 0);
  signal draw_cuad_int, draw_tria_int: std_logic;
  signal addr_int: unsigned(6 downto 0);
  



  --
  signal xcoor_cursor, xcoor_grid: unsigned(7 downto 0);
  signal ycoor_cursor, ycoor_grid: unsigned(8 downto 0);
  signal colour_code_cursor, colour_code_grid: unsigned(2 downto 0);
  signal draw_cuad_cursor, draw_cuad_grid: std_logic;
  signal draw_tria_cursor, draw_tria_grid: std_logic;
  signal addr_cursor, addr_init: unsigned(6 downto 0);

  -- seniales de la ram
  signal data_in: std_logic;
  signal data_out: std_logic;
  signal wr: std_logic;
  signal rd: std_logic;

  
  

  -- seniales que comuncian componentes internos
  signal grid_op_int: std_logic;
  signal done_grid_int: std_logic;
  signal del_screen_int, draw_line_int, vertical_int: std_logic;




  begin -- comienzo de pingpong_arch
  
  -- cableado de salida
  XCOOR <= xcoor_int;
  YCOOR <= ycoor_int;
  COLOUR_CODE <= colour_code_int;
  DRAW_CUAD <= draw_cuad_int;
  DRAW_TRIA <= draw_tria_int;
  DEL_SCREEN <= del_screen_int;
  DRAW_LINE <= draw_line_int;
  VERTICAL <= vertical_int;


  -- parte inicializacion
  addr_init <= "0000000";
  data_in <= '0';
  wr <= '0';
  



    
  



  -- seniales de salida con multiplexacion segun la senial rslave
  xcoor_int <= xcoor_cursor when rslave = '1' else xcoor_grid;
  ycoor_int <= ycoor_cursor when rslave = '1' else ycoor_grid;
  colour_code_int <= colour_code_cursor when rslave = '1' else colour_code_grid;
  draw_cuad_int <= draw_cuad_cursor when rslave = '1' else draw_cuad_grid;
  draw_tria_int <= draw_tria_cursor when rslave = '1' else draw_tria_grid;
  addr_int <= addr_cursor when rslave = '1' else addr_init;
  






  -- Instanciacion de componentes
  nono_gfx_grid: NONO_GRAPHICS_grid port map (
    clk => clk,
    reset_l => reset_l,

    GRID_OP => grid_op_int,
    DONE_DEL => DONE_DEL,
    DONE_FIG => DONE_FIG,

    XCOOR => xcoor_grid,
    YCOOR => ycoor_grid,
    COLOUR_CODE => colour_code_grid,
    DONE_GRID => done_grid_int,
    DEL_SCREEN => del_screen_int,
    DRAW_CUAD => draw_cuad_grid,
    DRAW_TRIA => draw_tria_grid,
    DRAW_LINE => draw_line_int,
    VERTICAL => vertical_int
  );


  nono_gfx_cursor: nono_graphics_cursor port map (
    clk => clk,
    reset_l => reset_l,

    UPDATE_CURSOR => UPDATE_CURSOR,
    TOGGLE_CURSOR => TOGGLE_CURSOR,
    DONE_FIG => DONE_FIG,
    sol_out => data_out,
    cursorx => CURSORX,
    cursory => CURSORY,

    XCOOR_int => xcoor_cursor,
    YCOOR_int => ycoor_cursor,
    COLOUR_CODE_int => colour_code_cursor,
    DRAW_CUAD_int => draw_cuad_cursor,
    DRAW_TRIA_int => draw_tria_cursor,
    DONE_UPDATE => DONE_UPDATE,
    DONE_TOGGLE => DONE_TOGGLE,
    addr_int => addr_cursor,
    rd_sol => rd
  );

  ram: SUBMOD_RAM port map (
    clk => clk,
    reset_l => reset_l,
    addr => addr_int,
    data_in => data_in,
    WR => wr,
    RD => rd,
    data_out => data_out
  );
  


  
  ----------------------------------------
  ------ UNIDAD DE CONTROL ---------------
  ----------------------------------------

  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  process (clk,reset_l)
    begin
      if reset_l='0' then epres<=E_W8_INI_NONO; -- estado inicial
        elsif clk'event and clk='1' then epres<=esig;
      end if;
  end process;
  
  -- proceso combinacional que determina el valor de esig (estado siguiente)
  process (epres, INI_NONO, done_grid_int)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E_W8_INI_NONO => 
          if (INI_NONO = '1') then 
            esig <= E_GRID_BUILDING; 
          else 
            esig <= E_W8_INI_NONO; 
          end if;
        when E_GRID_BUILDING => 
          if (done_grid_int = '1') then 
            esig <= E_SLAVE_MODE_START; 
          else 
            esig <= E_GRID_BUILDING; 
          end if;
        when E_SLAVE_MODE_START => esig <= E_SLAVE;
        when E_SLAVE => esig <= E_SLAVE;
      
        when others => esig <= epres;
      end case;
    end process;

  
  grid_op_int <= '1' when epres = E_GRID_BUILDING else '0';
  pr_slave <= '1' when epres = E_SLAVE_MODE_START else '0';



  ----------------------------------------
  ------ UNIDAD DE PROCESO ---------------
  ----------------------------------------

  -- biestable de la senial rslave
  process (clk,reset_l)
    begin
      if reset_l='0' then rslave<='0'; -- estado inicial
        elsif clk'event and clk='1' then 
          if (pr_slave = '1') then rslave <= '1';
          end if;
      end if;
  end process;
  


end NONO_GFX_arch;

