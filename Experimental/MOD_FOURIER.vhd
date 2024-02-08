-- Plantilla tipo para la descripcion de un modulo diseñado segun la 
-- metodologia vista en clase: UC+UP

-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed
use ieee.math_real.all;	-- libreria para operaciones con std_logic_vector
-- liberria para ufixed
use ieee.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector
--use ieee.float_generic_pkg.all;	-- libreria para tipo float

-- Declaracion entidad
entity mod_fourier_ent is
  port (
	clk,reset_l:  in std_logic;

  -- In
  input_a : in std_logic_vector (15 downto 0);
  input_b : in std_logic_vector (15 downto 0);
  output_div : out std_logic_vector (15 downto 0);
  output_divzeroerror : out std_logic
	
  );
end mod_fourier_ent;


architecture mod_fourier_arch of mod_fourier_ent is

  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E0, E1);
  
  -- fixed point con 8 bits de parte entera y 8 de parte decimal
    -- señal de tipo fixed
    signal y,z,valor ,seno: sfixed(7 downto -8);
    signal x: sfixed(7 downto -8);
    signal tmp : sfixed(8 downto -8);

  signal numero : real := 7.777;
  signal sampletext : real;
  signal sampletext2 : real;
  -- UC
  -- Variables dependientes del turno
  signal epres,esig: tipo_estado;

  -- UP
  -- variables de los compomentes
  -- MUX
  
  

  begin --


  y <= to_sfixed (3.1415, y); -- Uses y for the sizing only.
  z <= to_sfixed (numero, z); -- 777

-- sumar y + z y quedarse con los ultimos 16 bits
    tmp <= y + z;
    x <= tmp(7 downto -8);


  sampletext2 <= sin (2*3.1415*4.4444*to_real (x));
  sampletext <= sqrt(numero + to_real (x));
  valor <= to_sfixed (sampletext, valor);
    seno <= to_sfixed (sampletext2, seno);
  
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
  process (epres)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E0 => esig <= E1;
        when E1 => esig <= E0;
           
        when others => esig <= epres;
      end case;
    end process;

  


  ----------------------------------------
  ------ UNIDAD DE PROCESO ---------------
  ----------------------------------------
  
  




end mod_fourier_arch;

