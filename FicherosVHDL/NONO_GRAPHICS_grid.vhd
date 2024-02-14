-- Plantilla tipo para la descripcion de un modulo diseñado segun la 
-- metodologia vista en clase: UC+UP

-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed

-- Declaracion entidad
entity NONO_GRAPHICS_grid is
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
end NONO_GRAPHICS_grid;


architecture NONO_GRAPHICS_grid_arch of NONO_GRAPHICS_grid is

  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_W8_OP, E_W8_DEL, E_BEGIN_ROW, E_TRADUCCION1, E_DRAWCUAD, E_INCR_ROW, E_INCR_COL, E_LINEAV, E_DRAWLV, E_INCR_X, E_LINEAH, E_DRAWLH, E_INCR_Y, E_00_TRIA, E_DRAWTRIA, E_DONE_GRID);

  -- UC
  signal epres,esig: tipo_estado;
  
  -- senial para mux de traduccion de coordenadas
  signal grid_mode: std_logic_vector(1 downto 0); -- 00: cuadrado, 01: lineas, 10: triangulo, 11: del_screen
  signal pr_cuad, pr_line, pr_tria, pr_delscreen: std_logic; -- seniales para el mux de traduccion de coordenadas



  -- senial mux para seniales de condicion end_y y end_x

  -- seniales para mux del color_code

  
 
  -- seniales de registros
  signal XCOOR_reg, in_XCOOR_reg: unsigned(7 downto 0); signal ld_XCOOR_reg: std_logic;
  signal YCOOR_reg, in_YCOOR_reg: unsigned(8 downto 0); signal ld_YCOOR_reg: std_logic;

  -- seniales de coordenadas contadores
  signal true_coordx: unsigned(3 downto 0); signal incr_tcoordx, clr_tcoordx: std_logic; signal end_x: std_logic;
  signal true_coordy: unsigned(3 downto 0); signal incr_tcoordy, clr_tcoordy: std_logic; signal end_y: std_logic;
  -- seniales para la traduccion de true coords a coordenadas de pantalla segun el estado del mux
  signal tradCuad_x: unsigned(7 downto 0); signal tradCuad_y: unsigned(8 downto 0);
  signal mult: unsigned(8 downto 0);


  constant offset_x: unsigned(8 downto 0) := to_unsigned(23, 9);
  constant offset_y: unsigned(8 downto 0) := to_unsigned (43, 9);
  constant increment_per_coord: unsigned(4 downto 0) := to_unsigned (21, 5);

  

  begin -- comienzo de pingpong_arch
  
  -- cableado de salida
  XCOOR <= XCOOR_reg;
  YCOOR <= YCOOR_reg;


  

  -- traduccion entre coordenadas de matriz y coordenadas de pantalla
  
  mult <= (true_coordx * increment_per_coord) + offset_x;
  tradCuad_x <= mult(7 downto 0);
  tradCuad_y <= (true_coordy * increment_per_coord) + offset_y;

  -- mux de traduccion de coordenadas
  in_XCOOR_reg <= (tradCuad_x - to_unsigned(4, 8)) when grid_mode = "01" else tradCuad_x;
  in_YCOOR_reg <= (tradCuad_y - to_unsigned(4, 9)) when grid_mode = "01" else tradCuad_y;

  -- mux de colour_code
  -- colour_code codificado RGB por bit, en 00, blanco, en 01 negro, en 10 verde y en 11 magenta
  colour_code <=  "111" when (grid_mode = "00") else
                  "000" when (grid_mode = "01") else
                  "010" when (grid_mode = "10") else
                  "101";

  -- mux de condiciones end_x y end_y, solo varia en dos estados, en 00 y 01
  end_x <= '1' when (grid_mode = "00" and true_coordx = 9) or (grid_mode = "01" and true_coordx = 10) else '0';
  end_y <= '1' when (grid_mode = "00" and true_coordy = 9) or (grid_mode = "01" and true_coordy = 10) else '0';

      

  
  ----------------------------------------
  ------ UNIDAD DE CONTROL ---------------
  ----------------------------------------

  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  process (clk,reset_l)
    begin
      if reset_l='0' then epres<=E_W8_OP; -- estado inicial
        elsif clk'event and clk='1' then epres<=esig;
      end if;
  end process;
  
  -- proceso combinacional que determina el valor de esig (estado siguiente)
  process (epres, GRID_OP, DONE_DEL, DONE_FIG, end_x, end_y)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E_W8_OP => 
            if (GRID_OP = '1') then esig <= E_W8_DEL;
            else esig <= E_W8_OP;
            end if;
        when E_W8_DEL =>
          if (DONE_DEL = '1') then esig <= E_BEGIN_ROW;
          else esig <= E_W8_DEL;
          end if;
        when E_BEGIN_ROW => esig <= E_TRADUCCION1;
        when E_TRADUCCION1 => esig <= E_DRAWCUAD;
        when E_DRAWCUAD => 
          if (DONE_FIG = '1') then esig <= E_INCR_ROW;
          else esig <= E_DRAWCUAD;
          end if;
        when E_INCR_ROW => 
          if (end_x = '0') then 
            esig <= E_TRADUCCION1;
          elsif (end_x = '1' and end_y = '0') then 
            esig <= E_INCR_COL;
          elsif (end_x = '1' and end_y = '1') then 
            esig <= E_LINEAV;
          else 
            esig <= E_INCR_ROW;
          end if;
        
        when E_INCR_COL => esig <= E_TRADUCCION1;
        when E_LINEAV => esig <= E_DRAWLV;
        when E_DRAWLV => 
          if (DONE_FIG = '1') then
            esig <= E_INCR_X;
          else 
            esig <= E_DRAWLV;
          end if;
        when E_INCR_X =>
          if (end_x = '0') then 
            esig <= E_LINEAV;
          else 
            esig <= E_LINEAH;
          end if;
        when E_LINEAH => esig <= E_DRAWLH;
        when E_DRAWLH => 
          if (DONE_FIG = '1') then esig <= E_INCR_Y;
          else esig <= E_DRAWLH;
          end if;
        when E_INCR_Y => 
          if (end_y = '0') then esig <= E_LINEAH;
          else esig <= E_00_TRIA;
          end if;
        when E_00_TRIA => esig <= E_DRAWTRIA;
        when E_DRAWTRIA => 
          if (DONE_FIG = '1') then esig <= E_DONE_GRID;
          else esig <= E_DRAWTRIA;
          end if;
        when E_DONE_GRID => esig <= E_W8_OP;

      
        when others => esig <= epres;
      end case;
    end process;

  
  -- seinales de control por estado
  -- comun
  DRAW_LINE <= '1' when (epres = E_DRAWLV) or (epres = E_DRAWLH) else '0';

  CLR_TCOORDX <= '1' when (epres = E_BEGIN_ROW) or (epres = E_INCR_COL) or (epres = E_INCR_ROW and end_x = '1' and end_y = '1') or (epres = E_INCR_X and end_X = '1') or (epres = E_INCR_Y and end_y = '1') else '0';
  CLR_TCOORDY <= '1' when (epres = E_BEGIN_ROW) or (epres = E_INCR_X and end_X = '1') or (epres = E_INCR_Y and end_y = '1') else '0';


  -- E_W8_OP

  -- E_W8_DEL
  DEL_SCREEN <= '1' when epres = E_W8_DEL else '0';
  -- E_BEGIN_ROW
 
  -- E_TRADUCCION1
  LD_XCOOR_REG <= '1' when (epres = E_TRADUCCION1) or (epres = E_LINEAV) or (epres = E_LINEAH) or (epres = E_00_TRIA) else '0';
  LD_YCOOR_REG <= '1' when (epres = E_TRADUCCION1) or (epres = E_LINEAH) or (epres = E_00_TRIA) else '0';
  -- E_DRAWCUAD
  DRAW_CUAD <= '1' when epres = E_DRAWCUAD else '0';
  -- E_INCR_ROW
  INCR_TCOORDX <= '1' when (epres = E_INCR_ROW) or (epres = E_INCR_X) else '0';
  -- E_INCR_COL
  INCR_TCOORDY <= '1' when (epres = E_INCR_COL) or (epres = E_INCR_Y) else '0';
  
  
  -- E_DRAWLV
  VERTICAL <= '1' when epres = E_DRAWLV else '0';
  
  -- E_DRAWTRIA
  DRAW_TRIA <= '1' when epres = E_DRAWTRIA else '0';
  
  -- E_DONE_GRID
  DONE_GRID <= '1' when epres = E_DONE_GRID else '0';



  -- cambios de modo grid
  pr_cuad <= '1' when (epres = E_W8_DEL and DONE_DEL = '1') else '0';
  pr_line <= '1' when (epres = E_INCR_ROW and end_x = '1' and end_y = '1') else '0';
  pr_tria <= '1' when (epres = E_INCR_Y and end_y = '1') else '0';
  pr_delscreen <= '1' when (epres = E_W8_OP AND GRID_OP = '1') else '0';




  ----------------------------------------
  ------ UNIDAD DE PROCESO ---------------
  ----------------------------------------

  -- registros 
  process (clk,reset_l)
    begin
      if reset_l='0' then
        XCOOR_reg <= (others => '0');
        YCOOR_reg <= (others => '0');
      elsif clk'event and clk='1' then
        if (LD_XCOOR_REG = '1') then XCOOR_reg <= in_XCOOR_reg;
        end if;
        if (LD_YCOOR_REG = '1') then YCOOR_reg <= in_YCOOR_reg;
        end if;
      end if;
  end process;

  -- contador de coordenadas
  process (clk, reset_l)
    begin
      if reset_l='0' then
        true_coordx <= (others => '0');
      elsif clk'event and clk='1' then
        if (CLR_TCOORDX = '1') then true_coordx <= (others => '0');
        elsif (INCR_TCOORDX = '1') then true_coordx <= true_coordx + 1;
        end if;
      end if;
  end process;


  -- contador de coordenadas
  process (clk, reset_l)
    begin
      if reset_l='0' then
        true_coordy <= (others => '0');
      elsif clk'event and clk='1' then
        if (CLR_TCOORDY = '1') then true_coordy <= (others => '0');
        elsif (INCR_TCOORDY = '1') then true_coordy <= true_coordy + 1;
        end if;
      end if;
  end process;

  -- registro del modo de traduccion
  process (clk, reset_l)
    begin
      if reset_l='0' then
        grid_mode <= (others => '0');
      elsif clk'event and clk='1' then
        if (pr_cuad = '1') then grid_mode <= "00";
        elsif (pr_line = '1') then grid_mode <= "01";
        elsif (pr_tria = '1') then grid_mode <= "10";
        elsif (pr_delscreen = '1') then grid_mode <= "11";
        end if;
      end if;
  end process;

  


end NONO_GRAPHICS_grid_arch;

