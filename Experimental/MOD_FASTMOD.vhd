-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector

use ieee.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector


-- liberria para ufixed
--use ieee.float_generic_pkg.all;	-- libreria para tipo float

-- Declaracion entidad
entity MOD_FASTMOD is
  port (
	clk,reset_l:  in std_logic;

  -- In 
  MOD_OP: in std_logic;
  inp: in sfixed (15 downto -16);
  -- OUT
  DONE_MOD_OP: out std_logic;
  result: out sfixed (5 downto -26)
  );
end MOD_FASTMOD;


architecture MOD_FASTMOD_arch of MOD_FASTMOD is

  component register_sfixed
    port (
    clk,reset_l:  in std_logic;
  
    -- Entradas
    data_in: in sfixed(15 downto -16);
    ld: in std_logic;
  
    -- Salidas
    data_out: out sfixed(15 downto -16)
    );
  end component;



  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_W8_OP, E_FOR_A, E_BUCLE, E_RES, E_DONE);
  signal epres,esig: tipo_estado;


    
  -- seniales para el tflipflop

  signal dosPI: sfixed (4 downto -27); 

  signal i: unsigned (3 downto 0); signal decr_i, pr_i: std_logic;
  signal end_for, mayor_o_igual: std_logic;


  signal acum, in_acum: sfixed (15 downto -16); signal ld_acum: std_logic;
  signal subtract: sfixed (15 downto -16); 
  signal sub_value: sfixed (15 downto -16);
  signal res, in_res: sfixed (5 downto -26); signal ld_res: std_logic;
  signal set_acum: std_logic;

  begin 

  -- cableado
  result <= res;
  dosPI <= to_sfixed (6.283185307179586476925286766559, dosPI);

  register_acum: register_sfixed port map (clk, reset_l, in_acum,ld_acum,acum);
  register_res: register_sfixed port map (clk, reset_l, in_res,ld_res,res);


  ----------------------------------------
  ------ UNIDAD DE PROCESO ---------------
  ----------------------------------------

  mayor_o_igual <= '1' when acum >= subtract else '0';
  sub_value <= resize(acum - subtract, 15,-16);
  in_acum <= resize(inp, acum) when set_acum = '1' else sub_value;
  in_res <= resize(acum,res);


  -- subcract <= 2*pi 2^i, mux con i como senial de control
  subtract <= to_sfixed(6.283185307179586476925286766559, 15, -16) when i = "0000" else
               to_sfixed(12.566370614359172953850573533118, 15, -16) when i = "0001" else
               to_sfixed(25.132741228718345907701147066236, 15, -16) when i = "0010" else
               to_sfixed(50.265482457436691815402294132472, 15, -16) when i = "0011" else
               to_sfixed(100.530964914873383630804588264944, 15, -16) when i = "0100" else
               to_sfixed(201.06192982974676726160917652989, 15, -16) when i = "0101" else
               to_sfixed(402.12385965949353452321835305978, 15, -16) when i = "0110" else
               to_sfixed(804.24771931898706904643670611956, 15, -16) when i = "0111" else
               to_sfixed(1608.4954386379741380928734122391, 15, -16) when i = "1000" else
               to_sfixed(3216.9908772759482761857468244783, 15, -16) when i = "1001" else
               to_sfixed(6433.9817545518965523714936489566, 15, -16) when i = "1010" else
    --           to_sfixed(12867.963509103793104743987297913, 15, -16) when i = "1011" else
  --             to_sfixed(25735.927018207586209487974595826, 15, -16) when i = "1100" else
--               to_sfixed(51471.854036415172418975949191652, 15, -16) when i = "1101" else
               --to_sfixed(102943.70807283034483795189838330, 15, -16) when i = "1110" else
               --to_sfixed(205887.4161456606896759037967666, 15, -16) when i = "1111" else
               to_sfixed(0.0, 15, -16);

----------------------------------------
------ UNIDAD DE CONTROL ---------------
----------------------------------------

  decr_i <= '1' when ((epres = E_FOR_A and mayor_o_igual = '0' and end_for = '0') or (epres = E_bucle and mayor_o_igual = '0' and end_for = '0')) else '0';

  -- e_w8_op
  set_acum <= '1' when (epres = e_w8_op) else '0';
  

  -- e_res
  ld_res <= '1' when epres = E_RES else '0';
  ld_acum <= '1' when ((epres = e_w8_op and mod_op = '1' ) or (epres = e_for_a and mayor_o_igual = '1') or (epres = e_bucle and mayor_o_igual = '1')) else '0';
  pr_i <= '1' when (epres = e_w8_op and mod_op = '1') else '0';

  -- e_for_a

  --e_bucle

  -- E_output
  DONE_MOD_OP <= '1' when epres = e_done else '0';

  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  process (clk,reset_l)
    begin
      if reset_l='0' then epres<=E_W8_OP; -- estado inicial
        elsif clk'event and clk='1' then epres<=esig;
      end if;
  end process;
  
  -- proceso combinacional que determina el valor de esig (estado siguiente)
  process (epres, mod_op, mayor_o_igual, end_for)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E_W8_OP => if mod_op = '1' then esig <= e_for_a; else esig <= E_W8_OP; end if;
        when E_FOR_A => if mayor_o_igual = '1' then 
              esig <= e_bucle;
          elsif mayor_o_igual = '0' and end_for = '1' then
              esig <= E_RES;
          else 
              esig <= E_FOR_A;
          end if;
        when E_BUCLE => if mayor_o_igual = '1' then 
              esig <= e_bucle;
          elsif mayor_o_igual = '0' and end_for = '1' then
              esig <= E_RES;
          else 
              esig <= E_FOR_A;
          end if;

        when E_RES => esig <= E_DONE;
        when E_DONE => esig <= E_W8_OP;

        
        
           
        when others => esig <= epres;
      end case;
    end process;



  -- contaodr i
  process (clk, reset_l)
    begin
      if reset_l = '0' then i <= "0000";
        elsif clk'event and clk = '1' then
          if decr_i = '1' then
            i <= i - 1;
          elsif pr_i = '1' then
            i <= to_unsigned(9, 4);
          end if;
        end if;
    end process;
  
    end_for <= '1' when i = "0000" else '0';
  

  




end MOD_FASTMOD_arch;

