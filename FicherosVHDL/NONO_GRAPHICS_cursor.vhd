-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed

-- Declaracion entidad
entity nono_graphics_cursor is
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
end nono_graphics_cursor;

-- Declaracion arquitectura
architecture nono_graphics_cursor_arch of nono_graphics_cursor is

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





  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_W8_CURSOR, E_TRADUCCION1, E_READ, E_FLIP, E_DRAWCUAD, E_DONE_UPDATE, E_ESPERA, E_ESPERA2, E_TRADUCCION2, E_DRAWTRIA, E_CHECK_WIN, E_W8_RAMS, E_INCR_SAMECOUNT, E_WIN);
   
  -- UC
  signal epres,esig: tipo_estado;
  -- seniales de control

  signal v : unsigned (7 downto 0); -- valor intermedio
  signal action, sel, incr_if_same: std_logic;
  signal mux_dir, dir: unsigned (6 downto 0);

  signal offset_x_int: unsigned (8 downto 0);
  signal offset_y_int: unsigned (8 downto 0);

  signal valor_multiplicacion   : unsigned (8 downto 0);

  signal colour_code_inte: unsigned (2 downto 0);
  

  -- seniales para los registros rcusorx 4 bits
  signal rcursorx: unsigned (3 downto 0); signal ld_cursor: std_logic;
  signal rcursory: unsigned (3 downto 0);

  -- seniales de los registros xcoor, ycoor
  signal in_xcoor_int: unsigned (7 downto 0); signal ld_coords_int: std_logic;
  signal in_ycoor_int: unsigned (8 downto 0);


  -- seniales para multiplicaciones
  --signal xcoor_mult: unsigned ()

  -- contador de 7 bits, con senial de clear e incremento, otra senial de salida end_cont que se activa cuando llega a 100
  signal cont_dir: unsigned (6 downto 0); signal clr_cont, incr_cont: std_logic; signal end_cont: std_logic;


  signal same: unsigned (6 downto 0); signal incr_same: std_logic; signal win: std_logic;

 -- seniales para ram o banco de registro de 1 bit
  signal wr, rd: std_logic; signal data_out: std_logic;
  begin

    -- Instanciacion de la RAM
    RAM: SUBMOD_RAM port map(
      clk => clk,
      reset_l => reset_l,
      addr => mux_dir,
      data_in => '0',
      WR => wr,
      RD => rd,
      data_out => data_out
    );

  ----------------------------------------
  ------ Logica combinacional ---------------
  ----------------------------------------
  

  offset_x_int <= to_unsigned (17, 9);--"00000000";
  offset_y_int <= to_unsigned (57, 9);--"000000000";
  


  -- MUX para seleccionar direccion a memoria
  mux_dir <= dir when (sel = '0') else cont_dir;
  addr_int <= mux_dir;

  incr_same <= '1' when (incr_if_same = '1' and data_out = sol_out) else '0';

  action <= '1' when (update_cursor = '1' or toggle_cursor = '1') else '0';


  -- mux para seleccionar color
  -- cuando esta en el estado drawtria, el color es 010, cuando es drawcuad, el color depende de data_out, si es 0, es 000, si es 1, es 111
  colour_code_inte <=   "010" when (epres = E_DRAWTRIA) else
                        "111" when (data_out = '0') else
                        "000" when (data_out = '1') 
                        else "110";
  
  colour_code_int <= colour_code_inte;

  -- traduccion de cursor a coordenadas (in_xcoor_int <= rcursorx * (17+4) + offset_x_int)
   valor_multiplicacion <= (rcursorx * to_unsigned(17+4, 5) + offset_x_int);
   in_xcoor_int <= valor_multiplicacion(7 downto 0);

  -- traduccion de cursor a coordenadas (in_ycoor_int <= rcursory * (17+4) + offset_y_int)
  in_ycoor_int <= rcursory * to_unsigned(17+4, 5) + offset_y_int;

  -- trauduccion de cursor a direccion en memoria (dir <= rcursory*10 + rcursorx)
  v <= rcursory*10 + rcursorx;
  dir <=v(6 downto 0);

  


  
  ----------------------------------------
  ------ UNIDAD DE CONTROL ---------------
  ----------------------------------------

  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  process (clk,reset_l)
    begin
      if reset_l='0' then epres<=E_W8_CURSOR;
        elsif clk'event and clk='1' then epres<=esig;
      end if;
  end process;
  
  -- proceso combinacional que determina el valor de esig (estado siguiente)
  process (epres, action, UPDATE_CURSOR, TOGGLE_CURSOR, DONE_FIG, END_CONT, WIN)
    begin
      case epres is 
        when E_W8_CURSOR => 
          if (action = '1') then esig <= E_TRADUCCION1;
          else esig <= E_W8_CURSOR;
          end if;
        when E_TRADUCCION1 => 
          if (UPDATE_CURSOR = '1') then esig <= E_READ;
          elsif (TOGGLE_CURSOR = '1') then esig <= E_FLIP;
          else esig <= E_TRADUCCION1;
          end if;
        when E_READ => esig <= E_DRAWCUAD;
        when E_FLIP => esig <= E_READ;
        when E_DRAWCUAD => 
          if (done_fig = '0') then esig <= E_DRAWCUAD;
          elsif (done_fig = '1' and TOGGLE_CURSOR = '1') then esig <= E_CHECK_WIN;
          else esig <= E_DONE_UPDATE;
          end if;
        when E_DONE_UPDATE => esig <= E_ESPERA;
        when E_ESPERA => esig <= E_Espera2;
        when E_Espera2 => esig <= E_TRADUCCION2;
        when E_TRADUCCION2 => esig <= E_DRAWTRIA;
        when E_CHECK_WIN => esig <= E_W8_RAMS;
        when E_W8_RAMS => esig <= E_INCR_SAMECOUNT;
        when E_INCR_SAMECOUNT => 
          if (end_cont = '0') then esig <= E_CHECK_WIN;
          elsif (end_cont = '1' and win = '1') then esig <= E_WIN;
          else esig <= E_DRAWTRIA;
          end if;
        when E_DRAWTRIA => if (done_fig = '1') then esig <= E_W8_CURSOR;
          else esig <= E_DRAWTRIA;
          end if;
        when E_WIN => esig <= E_WIN;

        
          
        when others => esig <= epres;
      end case;
    end process;

  
  -- seinales de control por estado

  DONE_UPDATE <= '1' when (epres = E_DRAWCUAD and done_fig = '1' and TOGGLE_CURSOR = '0') or (epres = E_DONE_UPDATE) else '0';
  RD <= '1' when (epres = E_READ or epres = E_FLIP or epres = E_CHECK_WIN) else '0';
  LD_CURSOR <= '1' when ((epres = E_W8_CURSOR and action='1') or (epres = E_ESPERA) or (epres = E_ESPERA2)) else '0';
  LD_COORDS_INT <= '1' when (epres = E_TRADUCCION1 or epres = E_TRADUCCION2) else '0';

  -- E_FLIP
  WR <= '1' when (epres = E_FLIP) else '0';

  -- E_DRAWCUAD
  DRAW_CUAD_INT <= '1' when (epres = E_DRAWCUAD) else '0';
  CLR_CONT <= '1' when (epres = E_DRAWCUAD and DONE_FIG = '1' and TOGGLE_CURSOR = '1') else '0';
  -- E_CHECK_WIN
  RD_SOL <= '1' when (epres = E_CHECK_WIN) else '0';
  SEL <= '1' when (epres = E_CHECK_WIN) else '0';
  
  -- E_W8_RAMS
  INCR_IF_SAME <= '1' when (epres = E_W8_RAMS) else '0';
  INCR_CONT <= '1' when (epres = E_INCR_SAMECOUNT) else '0';

  -- E_DRAWTRIA
  DRAW_TRIA_INT <= '1' when (epres = E_DRAWTRIA) else '0';
  DONE_TOGGLE <= '1' when (epres = E_DRAWTRIA and DONE_FIG = '1' and TOGGLE_CURSOR = '1') else '0';
  
  
  


  ----------------------------------------
  ------ UNIDAD DE PROCESO ---------------
  ----------------------------------------
  
  -- REGISTROS
  -- registro de 4 bits para rcursorx
  process (clk, reset_l)
    begin
      if reset_l = '0' then rcursorx <= (others => '0');
        elsif clk'event and clk = '1' then
          if (ld_cursor = '1') then rcursorx <= cursorx;
          end if;
      end if;
  end process;

  -- registro de 4 bits para rcursory
  process (clk, reset_l)
    begin
      if reset_l = '0' then rcursory <= (others => '0');
        elsif clk'event and clk = '1' then
          if (ld_cursor = '1') then rcursory <= cursory;
          end if;
      end if;
  end process;

  -- registro de 8 bits para xcoor_int
  process (clk, reset_l)
    begin
      if reset_l = '0' then xcoor_int <= (others => '0');
        elsif clk'event and clk = '1' then
          if (ld_coords_int = '1') then xcoor_int <= in_xcoor_int;
          end if;
      end if;
  end process;

  -- registro de 9 bits para ycoor_int
  process (clk, reset_l)
    begin
      if reset_l = '0' then ycoor_int <= (others => '0');
        elsif clk'event and clk = '1' then
          if (ld_coords_int = '1') then ycoor_int <= in_ycoor_int;
          end if;
      end if;
  end process;

  -- contador de 7 bits
  process (clk, reset_l)
    begin
      if reset_l = '0' then cont_dir <= (others => '0');
        elsif clk'event and clk = '1' then
          if (incr_cont = '1') then cont_dir <= cont_dir + 1;
          elsif (clr_cont = '1') then cont_dir <= (others => '0');
          end if;
      end if;
  end process;
  end_cont <= '1' when (cont_dir = 99) else '0';


  -- contador de 7 bits
  process (clk, reset_l)
    begin
      if reset_l = '0' then same <= (others => '0');
        elsif clk'event and clk = '1' then
          if (incr_same = '1') then same <= same + 1;
          elsif (clr_cont = '1') then same <= (others => '0');
          end if;
      end if;
  end process;

  win <= '1' when (same = 100) else '0';



end nono_graphics_cursor_arch;

