-- Plantilla tipo para la descripcion de un modulo diseñado segun la 
-- metodologia vista en clase: UC+UP

-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed

-- Declaracion entidad
entity cmd_process is
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
end cmd_process;


architecture cmd_process_arch of cmd_process is

  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_W8_UART_GO, E_HANDSHAKE_INI, E_MODE_NONO, E_HANDSHAKE_NONO);

  
  
  -- UC
  -- Variables dependientes del turno
  signal epres,esig: tipo_estado;
  

  -- UP
    
 -- Registro 2 bits: RMODO
  signal RMODE: unsigned (1 downto 0);
  signal NONO_MODE, IMG_MODE: std_logic;

  -- Registro 8 bits: CHAR
  signal RCHAR: unsigned (7 downto 0);
  signal LD_CHAR: std_logic;
  
  -- Registro 3 bits: Command
  signal RCOMMAND, COD_CMD: std_logic_vector(2 downto 0);
  signal LD_COMMAND: std_logic;
  

  signal VALID_CHAR: std_logic;

  

  begin -- comienzo de pingpong_arch
  
  -- Salida de datos
  COMMAND <= RCOMMAND;


  ----------------------------------------
  ------ UNIDAD DE CONTROL ---------------
  ----------------------------------------

  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  process (clk,reset_l)
    begin
      if reset_l='0' then epres<=E_W8_UART_GO;
        elsif clk'event and clk='1' then epres<=esig;
      end if;
  end process;
  
  -- proceso combinacional que determina el valor de esig (estado siguiente)
  process (epres, CMD_PX_GO, RMODE, NONO_INIT_DONE, VALID_CHAR, DONE_CMD)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E_W8_UART_GO =>
            if (CMD_PX_GO = '1' and RMODE = "00") then 
              esig <= E_HANDSHAKE_INI;
            elsif (CMD_PX_GO = '1' and RMODE = "01") then 
              esig <= E_MODE_NONO;
            else 
              esig <= E_W8_UART_GO;
            end if;
        when E_HANDSHAKE_INI =>
            if(  NONO_INIT_DONE = '1') then 
              esig <= E_W8_UART_GO;
            else 
              esig <= E_HANDSHAKE_INI;
            end if;
        when E_MODE_NONO =>
          if (VALID_CHAR = '1') then 
            esig <= E_HANDSHAKE_NONO;
          else 
            esig <= E_W8_UART_GO;
          end if;
        when E_HANDSHAKE_NONO =>
          if (DONE_CMD = '1') then 
            esig <= E_W8_UART_GO;
          else 
            esig <= E_HANDSHAKE_NONO;
          end if;
        when others => esig <= epres;
      end case;
    end process;

  
  -- seinales de control por estado

  -- E_W8_UART_GO
  LD_CHAR <= '1' when (epres = E_W8_UART_GO and CMD_PX_GO = '1') else '0';

  -- E_HANDSHAKE_INI
  NONO_INI <= '1' when (epres = E_HANDSHAKE_INI) else '0';
  NONO_MODE <= '1' when (epres = E_HANDSHAKE_INI and NONO_INIT_DONE = '1') else '0';

  -- E_MODE_NONO
  LD_COMMAND <= '1' when (epres = E_MODE_NONO and VALID_CHAR = '1') else '0';

  -- E_HANDSHAKE_NONO
  OUT_CMD <= '1' when (epres = E_HANDSHAKE_NONO) else '0';



  ----------------------------------------
  ------ UNIDAD DE PROCESO ---------------
  ----------------------------------------


  -- Decodificador/codificador de comando
  -- 000 = UP, 001 = DOWN, 010 = LEFT, 011 = RIGHT, 100 = ACTION, 111 = INVALIDO
  -- w: up, s: down, a: left, d: right, " ": action
  COD_CMD <= "000" when RCHAR = "01110111" else -- w
             "001" when RCHAR = "01110011" else -- s
             "010" when RCHAR = "01100001" else -- a
             "011" when RCHAR = "01100100" else -- d
             "100" when RCHAR = "00100000" else -- " "
             "111"; -- INVALIDO

  

  VALID_CHAR <= '1' when COD_CMD /= "111" else '0';
    


-- Esquema registro 2 bits RMODO
process (clk, reset_l)
begin
  if reset_l = '0' then RMODE <= (others => '0');
  elsif clk'event and clk='1' then 
    if NONO_MODE = '1' then RMODE <= to_unsigned(1,2);
    --elsif IMG_MODO = '1' then RMODE <= to_unsigned(2,2); -- por si acaso en un futuro se utiliza
    end if;
  end if;
end process;


-- Esquema registro 8 bits CHAR
process (clk, reset_l)
begin
  if reset_l = '0' then RCHAR <= (others => '0');
  elsif clk'event and clk='1' then 
    if LD_CHAR = '1' then RCHAR <= CHAR;
    end if;
  end if;
end process;

-- Registro 3 bits COMMAND, carga COD_CMD
process (clk, reset_l)
begin
  if reset_l = '0' then RCOMMAND <= (others => '0');
  elsif clk'event and clk='1' then 
    if LD_COMMAND = '1' then RCOMMAND <= COD_CMD;
    end if;
  end if;
end process;

 

end cmd_process_arch;

