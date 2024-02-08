-- Plantilla tipo para la descripcion de un modulo diseñado segun la 
-- metodologia vista en clase: UC+UP

-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed

-- Declaracion entidad
entity mod_uart is
  port (
	clk,reset_l:  in std_logic;

  -- In
  RX : in std_logic;

  -- Out
  CMD_PX_GO : out std_logic;
  CHAR : out unsigned(7 downto 0)
  
  );
end mod_uart;


architecture mod_uart_arch of mod_uart is

  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_W8_RX, E_MITAD, E_LOOP, E_W8_TICK);

  
  
  -- UC
  -- Variables dependientes del turno
  signal epres,esig: tipo_estado;
  

  -- UP
    
  -- contador 4 bits: LOOP
  signal RLOOP: unsigned (3 downto 0);
  signal CLR_LOOP,INCR_LOOP: std_logic;
  signal END_LOOP: std_logic; -- when RLOOP = 8
  
  -- contador 10 bits: CONT
  signal RCONT: unsigned (9 downto 0);
  signal PR_CONT_HALF,PR_CONT_FULL, DECR_CONT: std_logic;
  signal END_CONT: std_logic;

  -- 8 bitshift register
  signal RSHIFT: unsigned (7 downto 0);
  signal BITSHIFT: std_logic;


  

  begin -- comienzo de pingpong_arch
  
  -- Salida de datos
  CHAR <= RSHIFT;


  ----------------------------------------
  ------ UNIDAD DE CONTROL ---------------
  ----------------------------------------

  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  process (clk,reset_l)
    begin
      if reset_l='0' then epres<=E_W8_RX;
        elsif clk'event and clk='1' then epres<=esig;
      end if;
  end process;
  
  -- proceso combinacional que determina el valor de esig (estado siguiente)
  process (epres, RX, END_CONT, END_LOOP)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E_W8_RX => 
            if (RX = '0') then    
              esig <= E_MITAD;
            else          
              esig <= E_W8_RX;
            end if;
        when E_MITAD =>
            if (END_CONT = '1') then
              esig <= E_LOOP;
            else
              esig <= E_MITAD;
            end if;
        when E_LOOP =>
            if (END_LOOP = '1') then
              esig <= E_W8_RX;
            else
              esig <= E_W8_TICK;
            end if;
        when E_W8_TICK =>
           if (END_CONT = '1') then
              esig <= E_LOOP;
            else
              esig <= E_W8_TICK;
            end if;
        when others => esig <= epres;
      end case;
    end process;

  
  -- seinales de control por estado
  -- comun
  DECR_CONT <= '1' when ((epres = E_W8_TICK) or (epres = E_MITAD)) else '0';


  -- E_W8_RX
  PR_CONT_HALF <= '1' when (epres = E_W8_RX and RX = '0') else '0';
  CLR_LOOP <= '1' when (epres = E_W8_RX and RX = '0') else '0';

  -- E_LOOP
  INCR_LOOP <= '1' when (epres = E_LOOP) else '0';
  PR_CONT_FULL <= '1' when (epres = E_LOOP) else '0';
  CMD_PX_GO <= '1' when (epres = E_LOOP and END_LOOP = '1') else '0';

  -- E_W8_TICK
  BITSHIFT <= '1' when (epres = E_W8_TICK and END_LOOP = '0' and END_CONT = '1') else '0';




  ----------------------------------------
  ------ UNIDAD DE PROCESO ---------------
  ----------------------------------------

  -- codigo apropiado para cada uno de los componentes de la UP
  

-- Esquema contador 4 bits LOOP
process (clk, reset_l)
begin
  if reset_l = '0' then RLOOP <= (others => '0');
  elsif clk'event and clk='1' then 
    if CLR_LOOP = '1' then RLOOP <= (others => '0');
    elsif INCR_LOOP = '1' then
      RLOOP <= RLOOP + 1;
    end if;
  end if;  
end process;
END_LOOP <= '1' when (RLOOP = 9) else '0';

-- Esquema contador 10 bits CONT
process (clk, reset_l)
begin
  if reset_l = '0' then RCONT <= (others => '0');
  elsif clk'event and clk='1' then 
    if PR_CONT_HALF = '1' then RCONT <= to_unsigned(325,10);
    elsif PR_CONT_FULL = '1' then RCONT <= to_unsigned(651,10);
    elsif DECR_CONT = '1' then RCONT <= RCONT - 1;
    end if;
  end if;
end process;
END_CONT <= '1' when (RCONT = 0) else '0';

 

-- Esquema 8 bitshift register, rellena desde la izquierda
process (clk, reset_l)
begin
  if reset_l = '0' then RSHIFT <= (others => '0');
  elsif clk'event and clk='1' then 
    if BITSHIFT = '1' then RSHIFT <= RX & RSHIFT(7 downto 1);
    end if;
    
  end if;
end process;


end mod_uart_arch;

