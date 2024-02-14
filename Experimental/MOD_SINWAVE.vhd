-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed
--use ieee.math_real.all;	-- libreria para operaciones con std_logic_vector

library ieee_proposed;
use ieee_proposed.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector
--use ieee.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector



-- Declaracion entidad
entity MOD_SINWAVE is
  port (
	clk,reset_l:  in std_logic;

  -- In 
  ASK_OP: in std_logic;
  x: in sfixed (15 downto -16);
  -- OUT
  DONE_OP: out std_logic;
  result: out sfixed (5 downto -26)
  );
end MOD_SINWAVE;




architecture MOD_SINWAVE_arch of MOD_SINWAVE is

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

  component mod_fastmod
  port (
    clk,reset_l:  in std_logic;

    -- In 
    MOD_OP: in std_logic;
    inp: in sfixed (15 downto -16);
    -- OUT
    DONE_MOD_OP: out std_logic;
    result: out sfixed (5 downto -26)
    );
end component;


  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_W8_OP, E_OPMOD, E_MODV, E_K, E_kmul, E_Y_QUAD, E_CALCS, E_CALC, E_CALC2, E_CALC3, E_A_CALC5, E_B_C, E_APROX, E_RES, E_OUTPUT);
  -- Variables dependientes del turno
  signal epres,esig: tipo_estado;


  -- variables para verificar resultado
  --signal real_mod, real_sin: real;


 -- seniales para mod_fastmod
  signal done_mod, mod_op: std_logic;



    
  -- seniales para el tflipflop

  signal dosPI: sfixed (4 downto -27);  signal piMedios: sfixed (4 downto -27);

  signal entrada, in_entrada: sfixed (5 downto -26); signal ld_entrada: std_logic;

  signal modv,in_modv: sfixed (5 downto -26);  signal ld_modv: std_logic;

  signal k, in_k: sfixed (15 downto 0); signal ld_k: std_logic;

  signal kmul, in_kmul: sfixed (5 downto -26); signal ld_kmul: std_logic;

  signal y, in_y: sfixed (5 downto -26); signal ld_y: std_logic;
  signal quadrant,in_quadrant: sfixed (2 downto 0);  signal ld_quadrant: std_logic;

  signal calc0, calc1: sfixed (5 downto -26);
  

  signal calc, in_calc: sfixed (5 downto -26); signal ld_calc: std_logic;

  signal calc2, in_calc2: sfixed (5 downto -26); signal ld_calc2: std_logic;

  signal calc3, in_calc3: sfixed (5 downto -26); signal ld_calc3: std_logic;

  signal calc5, in_calc5: sfixed (5 downto -26); signal ld_calc5: std_logic;



  signal a, in_a: sfixed (5 downto -26); signal ld_a: std_logic;

  signal b, in_b: sfixed (5 downto -26); signal ld_b: std_logic;

  signal c, in_c: sfixed (5 downto -26); signal ld_c: std_logic;

  signal aprox, in_aprox: sfixed (5 downto -26); signal ld_aprox: std_logic;

  signal res, in_res: sfixed (5 downto -26); signal ld_res: std_logic;





  -- cosas de sin

  





  begin 
  result <= res;
  --real_sin <= sin(to_real(x));
  --real_mod <= to_real(x) mod 6.283185307179586476925286766559;

  register_entrada: register_sfixed port map (clk, reset_l, in_entrada,ld_entrada,entrada);
  register_modv:    register_sfixed port map (clk, reset_l, in_modv,ld_modv,modv);
  register_kmul:    register_sfixed port map (clk, reset_l, in_kmul,ld_kmul,kmul);
  register_y:       register_sfixed port map (clk, reset_l, in_y,ld_y,y);
  register_calc:    register_sfixed port map (clk, reset_l, in_calc,ld_calc,calc);
  register_calc2:   register_sfixed port map (clk, reset_l, in_calc2,ld_calc2,calc2);
  register_calc3:   register_sfixed port map (clk, reset_l, in_calc3,ld_calc3,calc3);
  register_calc5:   register_sfixed port map (clk, reset_l, in_calc5,ld_calc5,calc5);
  register_a:       register_sfixed port map (clk, reset_l, in_a,ld_a,a);
  register_b:       register_sfixed port map (clk, reset_l, in_b,ld_b,b);
  register_c:       register_sfixed port map (clk, reset_l, in_c,ld_c,c);
  register_aprox:   register_sfixed port map (clk, reset_l, in_aprox,ld_aprox,aprox);
  register_res:     register_sfixed port map (clk, reset_l, in_res,ld_res,res);
 

  -- portmap mod_fastmod
  mod_fastmod_inst: mod_fastmod port map (clk, reset_l, mod_op, entrada, done_mod, in_modv);


--- rgb es todo negro, todo 0

dosPI <= to_sfixed (6.283185307179586476925286766559, dosPI);
piMedios <= to_sfixed (1.5707963267948966192313216916398, piMedios);


----------------------------------------
------ UNIDAD DE PROCESO ---------------
----------------------------------------
-- traducir variable valor a un numero de pixeles

in_entrada <= x;


-- Paso E_k
-- mapear k a un valor entre 0 y pimedios


--in_k <= resize ((modv - to_sfixed(    0.5, modv)), k);
in_k <= resize((modv- to_sfixed(    0.5, modv))*Reciprocal(piMedios), k);
-- k = modulo * 2/pi
--k <= resize (modulo * to_sfixed(1.5708,k), k);
in_kmul <= resize(k * piMedios, y);
-- Paso E_y_quad
-- y = tk - k*pi*0.5;
-- quadrant = k mod 4
in_y <= resize (modv - kmul, y);
in_quadrant <= resize (k mod to_sfixed(4, k), quadrant);


-- Paso E_Calcs
calc0 <= y;
calc1 <= resize (pimedios-y, calc1);

-- Paso E_Calc
process (quadrant, calc1, calc0)
begin
  case quadrant is

    when "000" => in_calc <= calc0;
    when "001" => in_calc <= calc1;
    when "010" => in_calc <= calc0;
    when "011" => in_calc <= calc1;
    when "100" => in_calc <= calc0;
    when "101" => in_calc <= calc1;
    when "110" => in_calc <= calc0;
    when "111" => in_calc <= calc1;
    when others => in_calc <= to_sfixed(0.0, 5, -26);

  end case;
end process;



-- mux para seleccionar el valor que se usa para calcular sin
-- si quadrant = 0, to_sin = y
-- si quadrant = 1, to_sin = piMedios - y
-- si quadrant = 2, to_sin = y
-- si quadrant = 3, to_sin = piMedios - y
--process (quadrant, y, piMedios, to_sin)
--begin
--  case quadrant is
--    when "000" =>
--      in_to_sin <= y;
--    when "001" =>
--      in_to_sin <= resize(piMedios - y, to_sin);
--
--    when "010" =>
--      in_to_sin <= resize(-y, to_sin);
--    when "011" =>
--      in_to_sin <= resize(-(piMedios - y), to_sin);
--    when others =>
--      in_to_sin <= to_sfixed(0.0, to_sin);
--  end case;
--end process;

-- aplicar taylor para calcular sin
-- aprox = tk - (tk_3 * Reciprocal(to_sfixed(6, tk_3)) - tk_5 * Reciprocal(to_sfixed(120, tk_5)))

-- paso e_calc2
in_calc2 <= resize(calc * calc, 5, -26);
-- paso e_calc3
in_calc3 <= resize (calc2 * calc, calc3);

-- paso e_a_calc5
in_a <= resize (calc3 * Reciprocal(to_sfixed(6, 15,-16)), a);
in_calc5 <= resize (calc3 * calc2, calc5);

-- paso e_b_c
in_b <= resize (calc5 * Reciprocal(to_sfixed(120, 15,-16)), b);
in_c <= resize (calc - a, c);

-- paso e_aprox
in_aprox <= resize (c + b, aprox);

-- paso e_res
process (quadrant, aprox, calc0)
begin
  case quadrant is

    when "000" => in_res <= aprox;
    when "001" => in_res <= aprox;
    when "010" => in_res <= resize(-aprox, 5, -26);
    when "011" => in_res <= resize(-aprox, 5, -26);
    when "100" => in_res <= aprox;
    when "101" => in_res <= aprox;
    when "110" => in_res <= resize(-aprox, 5, -26);
    when "111" => in_res <= resize(-aprox, 5, -26);
    when others => in_res <= to_sfixed(0.0, 5, -26);

  end case;
end process;

-- Paso E_output
-- resultado

 
----------------------------------------
------ UNIDAD DE CONTROL ---------------
----------------------------------------

  -- e_w8_op
  ld_entrada <= '1' when epres = E_W8_OP else '0';

  -- e_opmod
  mod_op <= '1' when epres = E_OPMOD else '0';
  -- e_modv
  ld_modv <= '1' when epres = E_OPMOD and done_mod = '1' else '0';

  -- e_k
  ld_k <= '1' when epres = E_K else '0';

  -- e_kmul
  ld_kmul <= '1' when epres = E_KMUL else '0';

  -- e_y_quad
  ld_y <= '1' when epres = E_Y_QUAD else '0'; 
  ld_quadrant <= '1' when epres = E_Y_QUAD else '0';

  -- e_calcs
  

  -- e_calc
  ld_calc <= '1' when epres = e_calc else '0';

  -- e_calc2
  ld_calc2 <= '1' when epres = E_CALC2 else '0';

  -- e_calc3
  ld_calc3 <= '1' when epres = E_CALC3 else '0';

  -- e_a_calc5
  ld_calc5 <= '1' when epres = E_A_calc5 else '0';
  ld_a <= '1' when epres = E_A_calc5 else '0';

  -- e_b
  ld_b <= '1' when epres = E_B_c else '0';
  ld_c <= '1' when epres = E_B_C else '0';

  -- e_aprox
  ld_aprox <= '1' when epres = E_APROX else '0';

  -- e_res
  ld_res <= '1' when epres = E_RES else '0';




  -- E_output
  DONE_OP <= '1' when epres = E_output else '0';

  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  process (clk,reset_l)
    begin
      if reset_l='0' then epres<=E_W8_OP; -- estado inicial
        elsif clk'event and clk='1' then epres<=esig;
      end if;
  end process;
  
  -- proceso combinacional que determina el valor de esig (estado siguiente)
  process (epres, ASK_OP, done_mod)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E_W8_OP => if ASK_OP = '1' then esig <= E_OPMOD; else esig <= E_W8_OP; end if;
        when E_OPMOD => if done_mod = '1' then esig <= E_MODV; else  esig <= E_OPMOD; end if;
        when E_MODV => esig <= E_K;
        when E_K => esig <= e_kmul;
        when E_KMUL => esig <= E_Y_QUAD;
        when E_Y_QUAD => esig <= E_CALCS;
        when E_CALCS => esig <= E_CALC;
        when E_CALC => esig <= E_CALC2;
        when E_CALC2 => esig <= E_CALC3;
        when E_CALC3 => esig <= E_A_CALC5;
        when E_A_CALC5 => esig <= E_B_C;
        when E_B_C => esig <= E_APROX;
        when E_APROX => esig <= E_RES;
        when E_RES => esig <= E_OUTPUT;

        when E_OUTPUT => esig <= E_W8_OP;
        
           
        when others => esig <= epres;
      end case;
    end process;


-- resto de registros


-- registro k
process (clk,reset_l)
begin 
  if reset_l = '0' then
    k <= (others => '0');
  elsif clk'event and clk = '1' then
    if ld_k = '1' then
      k <= in_k;
    end if;
  end if;
end process;


-- registro quadrant
process (clk,reset_l)
begin 
  if reset_l = '0' then
    quadrant <= (others => '0');
  elsif clk'event and clk = '1' then
    if ld_quadrant = '1' then
      quadrant <= in_quadrant;
    end if;
  end if;
end process;

  




end MOD_SINWAVE_arch;

