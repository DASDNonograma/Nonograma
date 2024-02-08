-- Plantilla tipo para la descripcion de un modulo diseñado segun la 
-- metodologia vista en clase: UC+UP

-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed
use ieee.math_real.all;	-- libreria para operaciones con std_logic_vector
--library ieee_proposed;


-- liberria para ufixed
--use ieee_proposed.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector
use ieee.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector
--use ieee.float_generic_pkg.all;	-- libreria para tipo float

-- Declaracion entidad
entity lcd_fourier_ent is
  port (
	clk,reset_l:  in std_logic;

  -- In 
  DONE_COLOUR: in std_logic;
  DONE_CURSOR: in std_logic;
	-- OUT
  OP_SETCURSOR: out std_logic;
  XCOL: out unsigned (7 downto 0);
  YROW: out unsigned (8 downto 0);
  OP_DRAWCOLOUR: out std_logic;
  NUMPIX: out unsigned (16 downto 0);
  RGB: out unsigned (15 downto 0)
  );
end lcd_fourier_ent;


architecture lcd_fourier_arch of lcd_fourier_ent is

  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_DRAWTICK, E_CALC_MULT, E_W8, E_MOD, E_SIN0, E_SIN1, E_SIN2, E_SINTK2, E_SINTK3, E_SINTK5, E_SINPOLS, E_SINSUB1, E_SINSUB2, E_SIN_APROX, E_SINMULT, E_FLOOR, E_SETCURSOR, E_DRAWCOLOUR, E_FIN);
  -- Variables dependientes del turno
  signal epres,esig: tipo_estado;


 -- Variables basicas
   
   signal Ryrow: unsigned (8 downto 0);
   signal end_loop: std_logic;
    signal incr_yrow: std_logic;

   signal in_numpix_floor, numpix_floor: unsigned (16 downto 0);
   signal ld_nimpix_floor: std_logic;
   signal numpix_integer: signed (16 downto 0);

   signal RRGB: unsigned (15 downto 0);




  -- contador de espera para dibujar un pixel, cada 0.003125 segundos
  signal clr_drawtick: std_logic;
  signal drawtick: unsigned (17 downto 0);
  signal draw: std_logic;

 
  -- seniales para el tflipflop
  signal tflipflop: std_logic;


  -- interconexion

  signal dosPI: sfixed (7 downto -8);
  signal piMedios: sfixed (7 downto -8);
  signal freq: sfixed (7 downto -8);

 -- TK
  signal tk: sfixed (8 downto -7);
  signal incr_tk: std_logic;
  signal ld_tk: std_logic;


 -- TK*freq
  signal in_mult: sfixed (6 downto -9);
  signal mult: sfixed (6 downto -9);
  signal ld_mult: std_logic;

-- mult mod 2p 
  signal modulo,in_modulo: sfixed (3 downto -12);
  signal ld_modulo: std_logic;

  -- Variable para el acumulador
  signal acumlador, in_acumulador: sfixed (7 downto -12);
  signal ld_acumulador: std_logic;
  signal resta_val: sfixed (7 downto -12);
  signal SEL,menor: std_logic;








  -- cosas de sin

  signal in_k,k: sfixed (7 downto 0);
  signal ld_k: std_logic;

  signal in_y,y : sfixed (7 downto -8);
  signal ld_y: std_logic;

  signal quadrant,in_quadrant: sfixed (2 downto 0);
  signal ld_quadrant: std_logic;


  signal in_to_sin,to_sin : sfixed (7 downto -8);
  signal ld_to_sin: std_logic;





  -- aproximando sin
  signal in_tk2,tk_2: sfixed (15 downto -16);
  signal ld_tk2: std_logic;
  

  signal in_tk3,tk_3: sfixed (15 downto -16);
  signal ld_tk3: std_logic;
  

  signal ld_tk5: std_logic;
  signal in_tk5, tk_5: sfixed (15 downto -16);

   -- 32 bits en total, 4 bits para la parte entera y 28 para la fraccionaria
  signal ld_pol1: std_logic;
  signal pol1,in_pol1: sfixed (3 downto -28);

  signal pol2, in_pol2: sfixed (3 downto -28);
  signal ld_pol2: std_logic;

  -- sub
  signal sub1, in_sub1: sfixed (15 downto -16);
  signal ld_sub1: std_logic;

  signal sub2, in_sub2: sfixed (15 downto -16);
  signal ld_sub2: std_logic;
  


  signal in_sin_aprox, sin_aprox: sfixed (2 downto -29);
  signal ld_sin_aprox: std_logic;

  signal sinaprox_mult, in_sinaprox_mult: sfixed (7 downto -24);
  signal ld_sinaprox_mult: std_logic;
--

  begin 

  
numpix <= numpix_floor;
yrow <= Ryrow;
--- rgb es todo negro, todo 0
rgb <= x"0000";


xcol <= to_unsigned (0, 8);

dosPI <= to_sfixed (6.283185307179586476925286766559, dosPI);

piMedios <= to_sfixed (1.5707963267948966192313216916398, piMedios);

freq <= to_sfixed (0.5, freq);

----------------------------------------
------ UNIDAD DE PROCESO ---------------
----------------------------------------
-- traducir variable valor a un numero de pixeles

-- tk * freq
in_mult <= resize(tk * freq, in_mult);


-- mux del in_acumulador, entre mult y resta_val, con seinal de control SEL
in_acumulador <= resta_val when (SEL = '1') else
        	   resize(mult, in_acumulador) ;

-- acumulador
resta_val <= resize (acumlador-dosPI, resta_val);
menor <= '1' when resta_val < resize(dosPi,resta_val) else '0';







-- modulo
--in_modulo <= resize (mult mod dosPI, in_modulo);



-- mapear k a un valor entre 0 y pimedios
-- k = modulo * 2/pi
--k <= resize (modulo * to_sfixed(1.5708,k), k);
in_k <= resize ((modulo - to_sfixed(    0.7854, modulo))* Reciprocal(piMedios), k);
 
-- y = tk - k*pi*0.5;
in_y <= resize (modulo - k * piMedios, y);

-- quadrant = k mod 4
in_quadrant <= resize (k mod to_sfixed(4, k), quadrant);

-- mux para seleccionar el valor que se usa para calcular sin
-- si quadrant = 0, to_sin = y
-- si quadrant = 1, to_sin = piMedios - y
-- si quadrant = 2, to_sin = y
-- si quadrant = 3, to_sin = piMedios - y
process (quadrant, y, piMedios, to_sin)
begin
  case quadrant is
    when "000" =>
      in_to_sin <= y;
    when "001" =>
      in_to_sin <= resize(piMedios - y, to_sin);

    when "010" =>
      in_to_sin <= resize(-y, to_sin);
    when "011" =>
      in_to_sin <= resize(-(piMedios - y), to_sin);
    when others =>
      in_to_sin <= to_sfixed(0.0, to_sin);
  end case;
end process;



-- aplicar taylor para calcular sin
-- aprox = tk - (tk_3 * Reciprocal(to_sfixed(6, tk_3)) - tk_5 * Reciprocal(to_sfixed(120, tk_5)))


in_tk2 <= resize (to_sin * to_sin, tk_2);

in_tk3 <= resize (tk_2 * to_sin, tk_3);

in_tk5 <= resize (tk_3 * tk_2, tk_5);

in_pol1 <= resize (tk_3 * Reciprocal(to_sfixed(6, tk_3)), pol1);
in_pol2 <= resize (tk_5 *  Reciprocal(to_sfixed(120, tk_5)), pol2);

in_sub1 <= resize (pol1- pol2, sub1);
in_sub2 <= resize (to_sin- sub1, sub2);


-- resultado


in_sin_aprox <= resize (sub2, sin_aprox);


in_sinaprox_mult <= resize (sin_aprox * to_sfixed(34.0,sinaprox_mult), sinaprox_mult);

-- numplix_floor es sinaproxmult truncado a 17 bits, quedarse solo con la parte entera, es decir, quedarse con los bits desde 0 hasta sinaprox_mult'high
in_numpix_floor <="000000000" & unsigned (sinaprox_mult(7 downto 0));





 
  ----------------------------------------
  ------ UNIDAD DE CONTROL ---------------
  ----------------------------------------


  -- señales de control
  -- E_DRAWTICK

  ld_mult <= '1' when epres = E_CALC_MULT else '0';
  -- E_W8
  

  ld_modulo <= '1' when epres = E_MOD else '0';
  clr_drawtick <= '1' when (epres = E_DRAWTICK and draw='1') else '0';
  incr_tk <= '1' when (epres = E_DRAWTICK and draw='1') else '0';
  ld_k <= '1' when epres = E_SIN0 else '0';
  ld_y <= '1' when epres = E_SIN1 else '0';
  ld_quadrant <= '1' when epres = E_SIN1 else '0';
  ld_to_sin <= '1' when epres = E_SIN2 else '0';

  -- E_SINTK2
  ld_tk2 <= '1' when epres = E_SINTK2 else '0';
  -- E_SINTK3
  ld_tk3 <= '1' when epres = E_SINTK3 else '0';
  -- E_SINTK5
  ld_tk5 <= '1' when epres = E_SINTK5 else '0';
  -- E_SINPOLS
  ld_pol1 <= '1' when epres = E_SINPOLS else '0';
  ld_pol2 <= '1' when epres = E_SINPOLS else '0';
  -- E_SINSUB1
  ld_sub1 <= '1' when epres = E_SINSUB1 else '0';
  -- E_SINSUB2
  ld_sub2 <= '1' when epres = E_SINSUB2 else '0';
  -- E_SIN_APROX
  ld_sin_aprox <= '1' when epres = E_SIN_APROX else '0';
  -- E_SINMULT
  ld_sinaprox_mult <= '1' when epres = E_SINMULT else '0';
  -- E_FLOOR
  ld_nimpix_floor <= '1' when epres = E_FLOOR else '0';
  -- E_SETCURSOR
  OP_SETCURSOR <= '1' when epres = E_SETCURSOR else '0';
  -- E_DRAWCOLOUR
  OP_DRAWCOLOUR <= '1' when epres = E_DRAWCOLOUR else '0';

  -- E_FIN
  incr_yrow <= '1' when epres = E_FIN else '0';





  -- proceso sincrono que actualiza el estado en flanco de reloj. Reset asincrono.
  process (clk,reset_l)
    begin
      if reset_l='0' then epres<=E_DRAWTICK; -- estado inicial
        elsif clk'event and clk='1' then epres<=esig;
      end if;
  end process;
  
  -- proceso combinacional que determina el valor de esig (estado siguiente)
  process (epres, draw, done_cursor, done_colour)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E_DRAWTICK => if draw = '1' then 
          esig <= E_CALC_MULT; else esig <= E_DRAWTICK; end if;
        
        when E_CALC_MULT => esig <= E_W8;
		  when E_W8 => esig <= E_MOD;
        when E_MOD => esig <= E_SIN0;
        when E_SIN0 => esig <= E_SIN1;
        when E_SIN1 => esig <= E_SIN2;
        when E_SIN2 => esig <= E_SINTK2;
        when E_SINTK2 => esig <= E_SINTK3;
        when E_SINTK3 => esig <= E_SINTK5;
        when E_SINTK5 => esig <= E_SINPOLS;
        when E_SINPOLS => esig <= E_SINSUB1;
        when E_SINSUB1 => esig <= E_SINSUB2;
        when E_SINSUB2 => esig <= E_SIN_APROX;
        when E_SIN_APROX => esig <= E_SINMULT;
        when E_SINMULT => esig <= E_FLOOR;
        when E_FLOOR => esig <= E_SETCURSOR;
        when E_SETCURSOR => if done_cursor = '1' then esig <= E_DRAWCOLOUR; else esig <= E_SETCURSOR; end if;
        when E_DRAWCOLOUR => if done_colour = '1' then esig <= E_FIN; else esig <= E_DRAWCOLOUR; end if;
        when E_FIN => esig <= E_DRAWTICK;
        
           
        when others => esig <= epres;
      end case;
    end process;






  -- acumulador
process (clk, reset_l)
  begin
    if reset_l = '0' then
      acumlador <= to_sfixed (0.0, acumlador);
    elsif clk'event and clk='1' then
      if ld_acumulador = '1' then
        acumlador <= in_acumulador;
      end if;
    end if;
  end process;




    -- registro sin_mult
process (clk, reset_l)
  begin
    if reset_l = '0' then
      sinaprox_mult <= to_sfixed (0.0, sinaprox_mult);
    elsif clk'event and clk='1' then
      if ld_sinaprox_mult = '1' then
        sinaprox_mult <= in_sinaprox_mult;
      end if;
    end if;
  end process;

  -- registro numpix_floor
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        numpix_floor <= to_unsigned (0, 17);
      elsif clk'event and clk='1' then
        if ld_nimpix_floor = '1' then
          numpix_floor <= in_numpix_floor;
        end if;
      end if;
    end process;


-- registro sin_aprox
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        sin_aprox <= to_sfixed (0.0, sin_aprox);
      elsif clk'event and clk='1' then
        if ld_sin_aprox = '1' then
          sin_aprox <= in_sin_aprox;
        end if;
      end if;
    end process;

 -- registro tk2
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        tk_2 <= to_sfixed (0.0, tk_2);
      elsif clk'event and clk='1' then
        if ld_tk2 = '1' then
          tk_2 <= in_tk2;
        end if;
      end if;
    end process;

  -- registro tk3
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        tk_3 <= to_sfixed (0.0, tk_3);
      elsif clk'event and clk='1' then
        if ld_tk3 = '1' then
          tk_3 <= in_tk3;
        end if;
      end if;
    end process;

  -- registro tk5
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        tk_5 <= to_sfixed (0.0, tk_5);
      elsif clk'event and clk='1' then
        if ld_tk5 = '1' then
          tk_5 <= in_tk5;
        end if;
      end if;
    end process;

  -- registro pol1
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        pol1 <= to_sfixed (0.0, pol1);
      elsif clk'event and clk='1' then
        if ld_pol1 = '1' then
          pol1 <= in_pol1;
        end if;
      end if;
    end process;

  -- registro pol2
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        pol2 <= to_sfixed (0.0, pol2);
      elsif clk'event and clk='1' then
        if ld_pol2 = '1' then
          pol2 <= in_pol2;
        end if;
      end if;
    end process;

  -- registro sub1
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        sub1 <= to_sfixed (0.0, sub1);
      elsif clk'event and clk='1' then
        if ld_sub1 = '1' then
          sub1 <= in_sub1;
        end if;
      end if;
    end process;

  -- registro sub2
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        sub2 <= to_sfixed (0.0, sub2);
      elsif clk'event and clk='1' then
        if ld_sub2 = '1' then
          sub2 <= in_sub2;
        end if;
      end if;
    end process;












  
    -- registro k
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        k <= to_sfixed (0.0, k);
      elsif clk'event and clk='1' then
        if ld_k = '1' then
          k <= in_k;
        end if;
      end if;
    end process;
  
  -- registro y
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        y <= to_sfixed (0.0, y);
      elsif clk'event and clk='1' then
        if ld_y = '1' then
          y <= in_y;
        end if;
      end if;
    end process;

-- registro quadrant
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        quadrant <= to_sfixed (0.0, quadrant);
      elsif clk'event and clk='1' then
        if ld_quadrant = '1' then
          quadrant <= in_quadrant;
        end if;
      end if;
    end process;


    -- registro to_sin
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        to_sin <= to_sfixed (0.0, to_sin);
      elsif clk'event and clk='1' then
        if ld_to_sin = '1' then
          to_sin <= in_to_sin;
        end if;
      end if;
    end process;


    -- contador de tk, aumenta con el menor valor que puede tomar 1/256
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        tk <= to_sfixed (0.0, tk);
      elsif clk'event and clk='1' then
        if incr_tk = '1' then
          --tk <= resize(tk + to_sfixed (0.00390625, tk), tk);
          tk <= resize(tk + to_sfixed (0.1, tk), tk);
        end if;
      end if;
    end process;


-- contador drawtick, cada 0.003125 segundos, con un reloj de 50MHz
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        drawtick <= to_unsigned (0, 18);
      elsif clk'event and clk='1' then
        if clr_drawtick = '1' then
          drawtick <= to_unsigned (0, 18);
        else 
          drawtick <= drawtick + 1;
        end if;
        
      end if;
    end process;

    -- para contar 156250 ciclos, 0.003125 segundos
    --draw <= '1' when drawtick = to_unsigned (156250, 18) else '0';
    draw <= '1' when drawtick = to_unsigned (200, 18) else '0';


  -- Contador de yrow
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        Ryrow <= to_unsigned (0, 9);
      elsif clk'event and clk='1' then
        if incr_yrow = '1' then
          Ryrow <= Ryrow + 1;
        end if;
      end if;
    end process;

  end_loop <= '1' when Ryrow = to_unsigned (319, 9) else '0';

  -- Toggle flipflip basado en el clk
    

  -- registro para mult
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        mult <= to_sfixed (0.0, mult);
      elsif clk'event and clk='1' then
        if ld_mult = '1' then
          mult <= in_mult;
        end if;
      end if;
    end process;

  -- registro para modulo
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        modulo <= to_sfixed (0.0, modulo);
      elsif clk'event and clk='1' then
        if ld_modulo = '1' then
          modulo <= in_modulo;
        end if;
      end if;
    end process;






end lcd_fourier_arch;

