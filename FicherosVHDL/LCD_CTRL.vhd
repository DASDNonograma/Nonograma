-- Plantilla tipo para la descripcion de un modulo diseñado segun la 
-- metodologia vista en clase: UC+UP

-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed

-- Declaracion entidad
entity lcd_ctrl_ent is
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
end lcd_ctrl_ent;


architecture lcd_ctrl_arch of lcd_ctrl_ent is

  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13, E14);

  
  
  -- UC
  -- Variables dependientes del turno
  signal epres,esig: tipo_estado;
  

  -- UP
  -- variables de los compomentes
  -- MUX
  signal CL_LCD_DATA: std_logic;
  -- register 8 bits  -> XCOL e YROW
  signal RXCOL: unsigned (7 downto 0);
  signal RYROW: unsigned (8 downto 0);
  signal LD_cursor:  std_logic;

  -- RGB y numpix
  signal rgb_int :unsigned (15 downto 0);
  signal RRGB: unsigned (15 downto 0);
  signal numpix_internal: unsigned (16 downto 0);
  
  signal LD_DRAW, DEC_PIX, END_PIX: std_logic;
  
  -- BUS de datos
  signal LCD_DATA_local: unsigned (15 downto 0);

  -- contador de comandos
  signal LD_2C, INC_DAT, CL_DAT: std_logic;
  signal QDAT: unsigned (2 downto 0);

-- Flippy
  signal RSDAT, RSCOM: std_logic;
  
  

  begin -- comienzo de pingpong_arch
  
  -- Cableado de salida
  LCD_DATA <= LCD_DATA_local;
  RGB_int <= RGB;
  
  
  ----------------------------------------
  ------ UNIDAD DE CONTROL ---------------
  ----------------------------------------

  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  process (clk,reset_l)
    begin
      if reset_l='0' then epres<=E0;
        elsif clk'event and clk='1' then epres<=esig;
      end if;
  end process;
  
  -- proceso combinacional que determina el valor de esig (estado siguiente)
  process (epres, QDAT, LCD_init_done, OP_SETCURSOR, OP_DRAWCOLOUR, END_PIX)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E0 => 
            if (LCD_init_done = '1' and OP_SETCURSOR = '1') then    
              esig <= E1;
            elsif (LCD_init_done = '1' and OP_SETCURSOR = '0' and OP_DRAWCOLOUR = '1') then 
              esig <= E14;
            else          
              esig <= E0;
            end if;
        when E1 => esig <= E2;
        when E2 => esig <= E3;
        when E3 => esig <= E4;
        when E4 => 
          
          case to_integer (QDAT) is
            when 0 => esig <= E13;
            when 1 => esig <= E13;
            when 2 => esig <= E12;
            when 3 => esig <= E13;
            when 4 => esig <= E13;
            when 5 => esig <= E11;
            when 6 => esig <= E5;
            when others => esig <= E0;
          end case;
          
        when E5 => esig <= E6;
        when E6 => esig <= E7;
        when E7 => esig <= E8;
        when E8 => esig <= E9;
        when E9 => 
            if end_pix = '1' then 
              esig <= E10;
            else 
              esig <= E6;
            end if;
        when E10 => esig <= E0;
        when E11 => esig <= E0;
        when E12 => esig <= E2;
        when E13 => esig <= E2;
        when E14 => esig <= E2;
        when others => esig <= epres;
      end case;
    end process;

  
  -- seinales de control por estado
  -- comun
  CL_LCD_DATA <= '0' when (epres = E1 or epres = E0 or epres = E14) else '1'; -- E0, E1, E14
  
  LCD_WR_N <= '0' when (epres = E2 or epres = E6) else '1'; -- E2, E6
  LCD_CS_N <= '0' when (epres = E2 or epres = E6) else '1'; -- E2, E6

  RSCOM <= '1' when (epres = E1 or epres = E12 or epres = E14) else '0'; -- E1, E12, E14
  INC_DAT <= '1' when (epres = E5 or epres = E12 or epres = E13) else '0'; -- E5, E12, E13

  RSDAT <= '1' when (epres = E5 or epres = E13) else '0'; -- E5, E13

  -- E1
  LD_CURSOR <= '1' when (epres = E1) else '0';
  CL_DAT <= '1' when (epres = E1) else '0';
 
  -- E7
  DEC_PIX <= '1' when (epres = E7) else '0';

  -- E10
  DONE_COLOUR <= '1' when (epres = E10) else '0';
  -- E11
  DONE_CURSOR <= '1' when (epres = E11) else '0';

  -- E14
  LD_DRAW <= '1' when (epres = E14) else '0';
  LD_2C <= '1' when (epres = E14) else '0';


  -- una asignacion condicional para cada señal de control que genera la UC
  

  LCD_DATA_local <= 
                    X"002A"       when (CL_LCD_DATA = '1' and QDAT = 0) else
                    X"0000"       when (CL_LCD_DATA = '1' and QDAT = 1) else
                    X"00" & RXCOL when (CL_LCD_DATA = '1' and QDAT = 2) else
                    X"002B"       when (CL_LCD_DATA = '1' and QDAT = 3) else
                    X"000" & "000" & RYROW(8) when (CL_LCD_DATA = '1' and QDAT = 4) else
                    X"00" & RYROW (7 downto 0) when (CL_LCD_DATA = '1' and QDAT = 5) else
                    X"002C" when (CL_LCD_DATA = '1' and QDAT = 6) else
                    RRGB    when (CL_LCD_DATA = '1' and QDAT = 7) else
                    X"0000"; -- CL_LCD_DATA = '0' o invalid QDAT
                    

  ----------------------------------------
  ------ UNIDAD DE PROCESO ---------------
  ----------------------------------------

  -- codigo apropiado para cada uno de los componentes de la UP
  
  -- esquema para XCOL register de 7 bits
  process (clk, reset_l) 
    begin
      if reset_l = '0' then RXCOL <= (others => '0');
      elsif clk'event and clk='1' then 
        if LD_CURSOR = '1' then
          RXCOL <= XCOL;
        end if;       
      end if;
  end process;

-- esquema YROW
  process (clk, reset_l) 
  begin
    if reset_l = '0' then RYROW <= (others => '0');
    elsif clk'event and clk='1' then 
      if LD_CURSOR = '1' then
        RYROW <= YROW;
      end if;
    end if;
  end process;


  -- esquema RGB
process (clk, reset_l) 
begin
  if reset_l = '0' then RRGB <= X"0000";
  elsif clk'event and clk='1' then 

    if LD_DRAW = '1' then
      RRGB <= RGB_int;
    end if;

  end if;
end process;


-- esquema para contador 17 bits
process (clk, reset_l)
  begin
    if reset_l = '0' then numpix_internal <= (others => '0');
    elsif clk'event and clk='1' then 
      if LD_DRAW = '1' then
        numpix_internal <= NUM_PIX;
      elsif DEC_PIX = '1' then
        numpix_internal <= numpix_internal - 1;
      end if;
    end if;  
end process;

END_PIX <= '1' when (numpix_internal = 0) else '0';

  -- esquema para contador 3 bits
  process (clk, reset_l)
    begin
      if reset_l = '0' then QDAT <= (others => '0');
      elsif clk'event and clk='1' then 
        if CL_DAT = '1' then QDAT <= "000";
        elsif LD_2C = '1' then
          QDAT <= "110";
        elsif INC_DAT = '1' then
          QDAT <= QDAT + 1;
        end if;

      end if;  
  end process;
  
  -- esquema para flip flop de LCD_RS
  process (clk, reset_l)
  begin
    if reset_l = '0' then LCD_RS <= '1';
    elsif clk'event and clk='1' then 
     
      if RSDAT = '1' then
        LCD_RS <= '1';
      elsif RSCOM = '1' then
        LCD_RS <= '0';
      end if;
    end if;
  end process;


end lcd_ctrl_arch;

