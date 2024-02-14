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
  DONE_CMD: in std_logic;
  DONE_BIT: in std_logic;

  -- Out
  COMMAND:  out std_logic_vector(2 downto 0);
  OUT_CMD:  out std_logic;
  INI_NONO: out  std_logic
  
  );
end cmd_process;


architecture cmd_process_arch of cmd_process is

  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_W8_UART_GO, E_CHECK_CODE, E_NOTIFY_INI, E_MODE_INI, E_HANDSHAKE_SOL, E_MODE_NONO, E_HANDSHAKE_NONO);

  
  
  -- UC
  -- Variables dependientes del turno
  signal epres,esig: tipo_estado;
  

  -- UP
    
 -- Registro 2 bits: RMODO
  signal RMODE: unsigned (1 downto 0);
  signal NONO_MODE, INI_MODE, IMG_MODE: std_logic;

  -- Registro 8 bits: CHAR
  signal RCHAR: unsigned (7 downto 0);
  signal LD_CHAR: std_logic;
  
  -- Registro 3 bits: Command
  signal RCOMMAND, COD_CMD, IN_COMMAND: std_logic_vector(2 downto 0);
  signal LD_COMMAND: std_logic;
  
  -- contador 7 bits
  signal CONT: unsigned (6 downto 0);
  signal INCR_CONT: std_logic;
  signal END_SOL: std_logic;



  -- variables de control
  signal IS_ONE: std_logic;
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
  process (epres, CMD_PX_GO, RMODE, VALID_CHAR, DONE_CMD, DONE_BIT)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E_W8_UART_GO =>
           if (CMD_PX_GO = '1') then 
            esig <= E_CHECK_CODE;
          else
            esig <= E_W8_UART_GO;
          end if;
        when E_CHECK_CODE =>
        if (VALID_CHAR = '0') then
          esig <= E_W8_UART_GO;
        elsif (VALID_CHAR = '1' and RMODE = "00") then
          esig <= E_NOTIFY_INI;
        elsif (VALID_CHAR = '1' and RMODE = "01") then
          esig <= E_MODE_INI;
        elsif (VALID_CHAR = '1' and RMODE = "10") then
          esig <= E_MODE_NONO;
        else
          esig <= E_W8_UART_GO;
        end if;
        when E_NOTIFY_INI => esig <= E_w8_UART_GO;
        when E_MODE_INI => esig <= E_HANDSHAKE_SOL;
        when E_HANDSHAKE_SOL =>
          if (DONE_BIT = '1') then 
            esig <= E_W8_UART_GO;
          else 
            esig <= E_HANDSHAKE_SOL;
          end if;
            
    
        when E_MODE_NONO => esig <= E_HANDSHAKE_NONO;
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
  INI_NONO <= '1' when (epres = E_NOTIFY_INI) else '0';
  INI_MODE <= '1' when (epres = E_NOTIFY_INI) else '0';
  NONO_MODE <= '1' when (epres = E_HANDSHAKE_SOL and end_sol = '1') else '0';

  -- E_MODE_NONO
  LD_COMMAND <= '1' when ((epres = E_MODE_NONO and VALID_CHAR = '1') or epres = E_MODE_INI) else '0';

-- E_MODE_INI
  INCR_CONT <= '1' when (epres = E_MODE_INI) else '0';

  -- E_HANDSHAKE_NONO
  OUT_CMD <= '1' when (epres = E_HANDSHAKE_NONO or epres = E_HANDSHAKE_SOL) else '0';



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
             "101" when RCHAR = "01101001" else -- i en ascii

             "111"; -- INVALIDO

  
  -- Multiplexor de IN_COMMAND, cuando rmode(0) = 0, es COD_CMD, cuando rmode(0) = 1, es "00"&IS_ONE
  IN_COMMAND <= COD_CMD when RMODE(0) = '0' else "00"&IS_ONE;

  VALID_CHAR <= '1' WHEN (RMODE = "00" and COD_CMD = "101") or (RMODE = "01") OR (RMODE = "10" and COD_CMD /= "111" and COD_CMD /= "101") ELSE '0';
  IS_ONE <= '1' when (RCHAR = "00110001") else '0';


-- Contador de 7 bits
process (clk, reset_l)
begin
  if reset_l = '0' then CONT <= (others => '0');
  elsif clk'event and clk='1' then 
    if INCR_CONT = '1' then CONT <= CONT + 1;
    end if;
  end if;
end process;
-- termina cuando cuenta hasta 100
END_SOL <= '1' when CONT = "1100100" else '0';

-- Esquema registro 2 bits RMODO
process (clk, reset_l)
begin
  if reset_l = '0' then RMODE <= (others => '0');
  elsif clk'event and clk='1' then 
    if NONO_MODE = '1' then RMODE <= to_unsigned(2,2);
    elsif INI_MODE = '1' then RMODE <= to_unsigned(1,2);
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

-- Registro 3 bits COMMAND
process (clk, reset_l)
begin
  if reset_l = '0' then RCOMMAND <= (others => '0');
  elsif clk'event and clk='1' then 
    if LD_COMMAND = '1' then RCOMMAND <= IN_COMMAND;
    end if;
  end if;
end process;

 

end cmd_process_arch;

