-- Plantilla tipo para la descripcion de un modulo diseñado segun la 
-- metodologia vista en clase: UC+UP

-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed

-- Declaracion entidad
entity nono_cursor is
  port (
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
  TOGGLE_CURSOR: out std_logic


	
  );
end nono_cursor;


architecture nono_cursor_arch of nono_cursor is

  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_W8_INI, E_W8_CMD, E_CMD_DECODE, E_REDRAW_CELL, E_REDRAW_CURSOR, E_TOGGLE);
   
  -- UC
  signal epres,esig: tipo_estado;
  -- seniales de control
  signal VERT: std_logic;
  signal cursor_cmd: std_logic;

  signal incr_decr: std_logic;


  -- MUX_X: entradas not_limit_x (0) y 0 (1), controlado con vert y salida countx (seniales ya definidas)  
  -- MUX_Y: entradas not_limit_y (1) y 0 (0), controlado con vert y salida county
  
  -- Seniales para registro de RCOMMAND
  signal RCOMMAND: std_logic_vector (2 downto 0);
  signal LD_COMMAND: std_logic;

  -- Seinales para contadores de CURSORX y CURSORY
  -- control: senial up_down, que suma o resta 1 al contador segun el valor de updown y countx o county
  signal UP_DOWN: std_logic;
  signal RCURSORX: unsigned (3 downto 0);
  signal RCURSORY: unsigned (3 downto 0);
  
  
  -- si countx es 1, suma o resta 1 a cursorx, segun el valor de up_down, lo mismo para county y cursory
  signal COUNTX: std_logic;
  signal COUNTY: std_logic;

  


  begin -- comienzo de pingpong_arch
  
  -- Cableado de salida
  CURSORX <= RCURSORX;
  CURSORY <= RCURSORY;

  -- decodificadores par vert, up_down y cursor_cmd
  
  -- vert = 1 cuando rcommand = "000", "001", los comandos relacionados con subir y baajar el cursor
  VERT <= '1' when (RCOMMAND = "000" or RCOMMAND = "001") else '0';
  -- up_down = 1 cuando rcommand = "000", "010", los comandos relacionados con subir (-1 y) y desplazar a la izquierda (-1 x)
  UP_DOWN <= '1' when (RCOMMAND = "001" or RCOMMAND = "011") else '0';
  -- cursor_cmd = 1, cuando rcommand no es accion (100)
  cursor_cmd <= '1' when (RCOMMAND /= "100") else '0';
  
  -- cuando incr_decr y vert son 1, county es 1, cuando incr_decr y vert son 0, countx es 1
  COUNTY <= '1' when (incr_decr = '1' and VERT = '1') else '0';
  COUNTX <= '1' when (incr_decr = '1' and VERT = '0') else '0';



  
  ----------------------------------------
  ------ UNIDAD DE CONTROL ---------------
  ----------------------------------------

  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  process (clk,reset_l)
    begin
      if reset_l='0' then epres<=E_W8_INI;
        elsif clk'event and clk='1' then epres<=esig;
      end if;
  end process;
  
  -- proceso combinacional que determina el valor de esig (estado siguiente)
  process (epres, nono_init_done, OUT_COMMAND, cursor_cmd, done_update, done_toggle)
    begin
      case epres is 
        when E_W8_INI => if (nono_init_done = '1') then esig <= E_W8_CMD; else esig <= E_W8_INI; end if;
        when E_W8_CMD => if (OUT_COMMAND = '1') then esig <= E_CMD_DECODE; else esig <= E_W8_CMD; end if;
        when E_CMD_DECODE => if (cursor_cmd = '1') then esig <= E_REDRAW_CELL; else esig <= E_TOGGLE ; end if;
        when E_REDRAW_CELL => if (done_update = '1') then esig <= E_REDRAW_CURSOR; else esig <= E_REDRAW_CELL; end if;
        when E_REDRAW_CURSOR => if (done_update = '1') then esig <= E_W8_CMD; else esig <= E_REDRAW_CURSOR; end if;
        when E_TOGGLE => if (done_toggle = '1') then esig <= E_W8_CMD; else esig <= E_TOGGLE; end if;  
       
        when others => esig <= epres;
      end case;
    end process;

  
  -- seinales de control por estado
  LD_COMMAND <= '1' when (epres = E_W8_CMD and OUT_COMMAND = '1') else '0';

  update_cursor <= '1' when (epres = E_REDRAW_CURSOR or epres = E_REDRAW_CELL) else '0';
  toggle_cursor <= '1' when (epres = E_TOGGLE) else '0';

  incr_decr <= '1' when (epres = E_REDRAW_CELL and done_update = '1') else '0';


  ----------------------------------------
  ------ UNIDAD DE PROCESO ---------------
  ----------------------------------------
  -- codigo apropiado para cada uno de los componentes de la UP
 
  -- registro de RCOMMAND
  process (clk, reset_l)
    begin
      if reset_l = '0' then RCOMMAND <= "000";
        elsif clk'event and clk='1' then
          if LD_COMMAND = '1' then RCOMMAND <= COMMAND;
          end if;
      end if;
  end process;

  -- contador de CURSORX, limite entre 0 y 9
  process (clk, reset_l)
    begin
      if reset_l = '0' then RCURSORX <= "0000";
        elsif clk'event and clk='1' then
          if COUNTX = '1' then
            if UP_DOWN = '1' then
              if RCURSORX /= "1001" then RCURSORX <= RCURSORX + 1;
              end if;
            else
              if RCURSORX /= "0000" then RCURSORX <= RCURSORX - 1;
              end if;
            end if;
          end if;
      end if;
  end process;


  -- contador de CURSORY, limite entre 0 y 9
  process (clk, reset_l)
    begin
      if reset_l = '0' then RCURSORY <= "0000";
        elsif clk'event and clk='1' then
          if COUNTY = '1' then
            if UP_DOWN = '1' then
              if RCURSORY /= "1001" then RCURSORY <= RCURSORY + 1;
              end if;
            else
              if RCURSORY /= "0000" then RCURSORY <= RCURSORY - 1;
              end if;
            end if;
          end if;
      end if;
  end process;

  


end nono_cursor_arch;

