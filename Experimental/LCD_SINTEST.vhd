-- Plantilla tipo para la descripcion de un modulo diseñado segun la 
-- metodologia vista en clase: UC+UP

-- Declaracion librerias
library ieee;
use ieee.std_logic_1164.all;	-- libreria para tipo std_logic
use ieee.numeric_std.all;	-- libreria para tipos unsigned/signed
--use ieee.math_real.all;	-- libreria para operaciones con std_logic_vector
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector

-- liberria para ufixed

--use ieee.fixed_pkg.all;	-- libreria para operaciones con std_logic_vector
--use ieee.float_generic_pkg.all;	-- libreria para tipo float

-- Declaracion entidad
entity LCD_SINTEST is
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
end LCD_SINTEST;


architecture lcd_sintest_arch of LCD_SINTEST is



  component MOD_SINWAVE
    port (
    clk,reset_l:  in std_logic;
  
    -- In 
    ASK_OP: in std_logic;
    x: in sfixed (15 downto -16);
    -- OUT
    DONE_OP: out std_logic;
    result: out sfixed (5 downto -26)
    );
  end component;




  -- declaracion de tipos y señales internas del sistema
  --	tipo nuevo para el estado de la UC y dos señales de ese tipo
  type tipo_estado is (E_DRAWTICK, E_CALC_MULT, E_W8, E_SINMULT, E_FLOOR, E_SETCURSOR, E_DRAWCOLOUR, E_FIN);
  -- Variables dependientes del turno
  signal epres,esig: tipo_estado;

  signal intermedio: sfixed (15 downto -16);
  signal ASK_op, done_op: std_logic;
  

 -- Variables basicas
   
   signal Ryrow: unsigned (8 downto 0);
   signal end_loop: std_logic;
    signal incr_yrow: std_logic;

   signal in_numpix_floor, numpix_floor, numpix_integer: unsigned (16 downto 0);
   signal ld_nimpix_floor: std_logic;

   signal RRGB: unsigned (15 downto 0);
   



  -- contador de espera para dibujar un pixel, cada 0.003125 segundos
  signal clr_drawtick: std_logic;
  signal drawtick: unsigned (17 downto 0);
  signal draw: std_logic;

 
-- senial para rnumpix
  signal in_rNUMPIX: unsigned (16 downto 0);
  signal rNUMPIX: unsigned (16 downto 0);
  signal ld_rNUMPIX: std_logic;

  -- interconexion

  
  signal freq: sfixed (7 downto -8);

 -- TK
  signal tk: sfixed (8 downto -7);  signal incr_tk: std_logic;  

 -- TK*freq
  signal in_mult: sfixed (15 downto -16);  signal mult: sfixed (15 downto -16);  signal ld_mult: std_logic;

  signal sin_aprox: sfixed (5 downto -26);
  

  signal sinaprox_mult, in_sinaprox_mult: sfixed (8 downto -23);
  signal ld_sinaprox_mult: std_logic;

  signal MUX_R, MUX_G, MUX_B, R, G, B1,B2,B3, in_R, in_G, in_B1, in_B2, in_B3: ufixed (5 downto -10);
  signal ld_colors: std_logic;
  signal umbral: unsigned (1 downto 0);

  signal aux1, aux2, aux3: ufixed (7 downto -8);
--

  begin 

  -- decodificador umbral, por franja
  umbral <= "00" when RNUMPIX <= to_unsigned (47, 17) else
            "01" when RNUMPIX <= to_unsigned (143, 17) else
            "10" when RNUMPIX <= to_unsigned (191, 17) else
            "11";




  -- interpolacion de colores
  -- franjas numpix: 0-47 (0), 48-95(1), 96-191(2), 192-239(3)
  -- 0-47
  -- MUX de R controlado por senial de control umbral, franja 0 = 0, franja 1 = (numpix-48)*(1/6), franja 2 = 1f, franja 3 = 1f

  aux1 <= to_ufixed((RNUMPIX - to_unsigned (48, 17)),7, -8);
  in_R <=  resize( aux1 * reciprocal(to_ufixed (3, 5, -10)), 5, -10);
  MUX_R <= to_ufixed (0, 5, -10)  when umbral = "00" else
           R                      when umbral = "01" else
           to_ufixed (31, 5, -10) when umbral = "10" else
           to_ufixed (31, 5, -10) when umbral = "11" else
            to_ufixed (0, 5, -10);

  -- MUX de G controlado por senial de control umbral, franja 0 = 0, franja 1 = 0, franja 2 = G, franja 3 = 3f
  -- G = (num_pix - 96) + (num_pix - 96) * (1/3)
  aux2 <= to_ufixed((RNUMPIX - to_unsigned (144, 17)),7, -8);
  in_G <= resize( aux2 + aux2 * reciprocal(to_ufixed (3, 5, -10)), 5, -10);
  mux_g <= to_ufixed (0, 5, -10) when umbral = "00" else
           to_ufixed (0, 5, -10) when umbral = "01" else
           G when umbral = "10" else
           to_ufixed (63, 5, -10) when umbral = "11" else
            to_ufixed (0, 5, -10);

  -- MUX de B controlado por senial de control umbral, franja 0 = B1, franja 1 = B2, franja 2 = 0, franja 3 = b3
  -- B1 = numpix_integer * (1/3)
  -- B2 = 32 - R
  -- B3 = (numpix_integer - 192) * (1/3)
  aux3 <=to_ufixed((RNUMPIX - to_unsigned (192, 17)),7, -8);
  in_B1 <= resize(to_ufixed(RNUMPIX,5, -10) * reciprocal(to_ufixed (1.5, 5, -10)), 5, -10);
  in_B2 <= resize(to_ufixed(31.5,5, -10) - R, 5, -10);
  in_B3 <= resize( aux3* reciprocal(to_ufixed (1.5, 5, -10)), 5, -10);
  MUX_B <= B1 when umbral = "00" else
           B2 when umbral = "01" else
           to_ufixed (0, 5, -10) when umbral = "10" else
           B3 when umbral = "11" else 
            to_ufixed (0, 5, -10);


  -- conectar seniales de colores en RRGB
  RRGB <= unsigned(MUX_R(4 downto 0)) & unsigned(MUX_G(5 downto 0)) & unsigned(MUX_B(4 downto 0));


  intermedio <= resize (mult, 15,-16);


  -- MODULO DE SINWAVE
  sinwave: MOD_SINWAVE port map (
    clk => clk,
    reset_l => reset_l,
    ASK_OP => ASK_op,
    x => intermedio,
    DONE_OP => done_op,
    result => sin_aprox
  );
  
  -- sumarle tk
numpix_integer <= numpix_floor + unsigned (tk(7 downto 0));

-- mux para el valor de numpix, si se pasa de 239, se pone 239
in_rNUMPIX <= numpix_integer when numpix_integer <= to_unsigned (239, 17) else to_unsigned (239, 17);
numpix <= rNUMPIX;

yrow <= Ryrow;
--- rgb es todo negro, todo 0
rgb <=rrgb;


xcol <= to_unsigned (0, 8);


freq <= to_sfixed (0.5, freq);

----------------------------------------
------ UNIDAD DE PROCESO ---------------
----------------------------------------
-- traducir variable valor a un numero de pixeles

-- tk * freq
in_mult <= resize(tk * freq, in_mult);


in_sinaprox_mult <= resize ((sin_aprox + to_sfixed(1.01,15,-16) )* to_sfixed(34.0,sinaprox_mult), sinaprox_mult);

-- numplix_floor es sinaproxmult truncado a 17 bits, quedarse solo con la parte entera, es decir, quedarse con los bits desde 0 hasta sinaprox_mult'high
in_numpix_floor <="000000000" & unsigned (sinaprox_mult(7 downto 0));





 
  ----------------------------------------
  ------ UNIDAD DE CONTROL ---------------
  ----------------------------------------


  -- señales de control
  -- E_DRAWTICK

  ld_mult <= '1' when epres = E_CALC_MULT else '0';
  -- E_W8
  

  clr_drawtick <= '1' when (epres = E_DRAWTICK and draw='1') else '0';
  incr_tk <= '1' when (epres = E_DRAWTICK and draw='1') else '0';

  ask_op <= '1' when (epres = E_w8) else '0';
  -- E_SINMULT
  ld_sinaprox_mult <= '1' when (epres = E_SINMULT) else '0';
  -- E_FLOOR
  ld_nimpix_floor <= '1' when epres = E_FLOOR else '0';
  -- E_SETCURSOR
  OP_SETCURSOR <= '1' when epres = E_SETCURSOR else '0';
  ld_rNUMPIX <= '1' when epres = E_SETCURSOR else '0';
  ld_Colors <= '1' when epres = E_SETCURSOR else '0';
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
  process (epres, draw, done_cursor, done_colour, done_op)
    begin
      case epres is 
      -- una clausula when por cada estado posible
        when E_DRAWTICK => if draw = '1' then 
          esig <= E_CALC_MULT; else esig <= E_DRAWTICK; end if;
        
        when E_CALC_MULT => esig <= E_W8;
		  
        when E_W8 => if (done_op = '1') then esig <= E_SINMULT; else esig <= E_W8; end if;
         
        
        when E_SINMULT => esig <= E_FLOOR;
        when E_FLOOR => esig <= E_SETCURSOR;
        when E_SETCURSOR => if done_cursor = '1' then esig <= E_DRAWCOLOUR; else esig <= E_SETCURSOR; end if;
        when E_DRAWCOLOUR => if done_colour = '1' then esig <= E_FIN; else esig <= E_DRAWCOLOUR; end if;
        when E_FIN => esig <= E_DRAWTICK;
        
           
        when others => esig <= epres;
      end case;
    end process;




    -- contador de tk, aumenta con el menor valor que puede tomar 1/256
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        tk <= to_sfixed (0.0, 8, -7);
      elsif clk'event and clk='1' then
        if incr_tk = '1' then
          --tk <= resize(tk + to_sfixed (0.00390625, tk), tk);
          tk <= resize(tk + to_sfixed (0.1, tk), tk);
        end if;
      end if;
    end process;


  -- registro sinaprox_mult
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        sinaprox_mult <= to_sfixed (0.0, 8, -23);
      elsif clk'event and clk='1' then
        if ld_sinaprox_mult = '1' then
          sinaprox_mult <= in_sinaprox_mult;
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
    draw <= '1' when drawtick > to_unsigned (156250, 18) else '0';


  -- Contador de yrow
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        Ryrow <= to_unsigned (0, 9);
      elsif clk'event and clk='1' then
        if incr_yrow = '1' then
          Ryrow <= Ryrow + 1;
        elsif end_loop = '1' then
          Ryrow <= to_unsigned (0, 9);
        end if;

      end if;
    end process;

  end_loop <= '1' when Ryrow > to_unsigned (319, 9) else '0';

  -- Toggle flipflip basado en el clk
    

  -- registro para mult
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        mult <= to_sfixed (0.0, 15,-16);
      elsif clk'event and clk='1' then
        if ld_mult = '1' then
          mult <= in_mult;
        end if;
      end if;
    end process;

 
-- registro num_pix
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        numpix_floor <= to_unsigned (34, 17);
      elsif clk'event and clk='1' then
        if ld_nimpix_floor = '1' then
          numpix_floor <= in_numpix_floor;
        end if;
      end if;
    end process;

    -- registro para rNUMPIX
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        rNUMPIX <= to_unsigned (34, 17);
      elsif clk'event and clk='1' then
        if ld_rNUMPIX = '1' then
          rNUMPIX <= in_rNUMPIX;
        end if;
      end if;
    end process;
  

 -- registros R, G, B1, B2, B3
  process (clk, reset_l)
    begin
      if reset_l = '0' then
        R <= to_ufixed (0, 5, -10);
        G <= to_ufixed (0, 5, -10);
        B1 <= to_ufixed (0, 5, -10);
        B2 <= to_ufixed (0, 5, -10);
        B3 <= to_ufixed (0, 5, -10);
      elsif clk'event and clk='1' then
        if ld_colors = '1' then
          R <= in_R;
          G <= in_G;
          B1 <= in_B1;
          B2 <= in_B2;
          B3 <= in_B3;
        end if;
      end if;
    end process;



end lcd_sintest_arch;

