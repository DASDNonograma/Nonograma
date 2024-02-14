-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed
--use ieee.math_real.all;	-- libreria para operaciones con std_logic_vector
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector

use ieee.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector

-- liberria para ufixed
--use ieee.float_generic_pkg.all;	-- libreria para tipo float

-- Declaracion entidad
entity register_sfixed is
  port (
	clk,reset_l:  in std_logic;

  -- Entradas
  data_in: in sfixed(5 downto -26);
  ld: in std_logic;

  -- Salidas
  data_out: out sfixed(5 downto -26)


  );
end register_sfixed;


architecture register_sfixed_arch of register_sfixed is

  signal data_out_int: sfixed(5 downto -26):= to_sfixed(0,5,-26);

  

  begin 

  data_out <= data_out_int;

  process(clk,reset_l)
  begin
    if reset_l = '0' then
      data_out_int <= to_sfixed(0,5,-26);
    elsif clk'event and clk = '1' then
      if ld = '1' then
        data_out_int <= data_in;
      end if;
    end if;
  end process;
  





end register_sfixed_arch;

