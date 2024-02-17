library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity nono_graphics is

    port(
        Clk,Reset_L: in std_logic;
        --IN
        OUT_CMD,DONE_DEL,DONE_FIG,UPDATE_CURSOR,TOGGLE_CURSOR,NONO_INI: in std_logic;
        COMMAND: in std_logic_vector(2 downto 0);
        CURSOR_POSX, CURSOR_POSY: in unsigned(3 downto 0);
        --OUT
        DRAW_TRIA,DRAW_CUAD,DRAW_LINE,DEL_SCREEN,VERTICAL: out std_logic;
        DONE_UPDATE,DONE_TOGGLE,NONO_init_DONE,DONE_BIT: out std_logic;
        XCOOR: out unsigned(7 downto 0);
        YCOOR: out unsigned(8 downto 0);
        COLOUR_CODE: out unsigned(2 downto 0) 
    );

end nono_graphics;

architecture arch_nono_graphics of nono_graphics is
    type estado is (E_W8_INI,E_W8_CMD,E_LD_SOL,E_W8_DEL,E_CL_FIG,E_LD_POS,E_DIB_FIG,E_W8_CURSOR);
    signal epres,esig: estado;

    signal CONT_FIG: unsigned(1 downto 0);
    signal SOL: std_logic_vector(0 to 99);
    signal RXPOS,RYPOS: unsigned(3 downto 0);
    signal XINI,RXLINE,RXCUAD,XLINE,XCUAD: unsigned(7 downto 0);
    signal YINI,RYLINE,RYCUAD,YLINE,YCUAD: unsigned(8 downto 0);
    signal CONT_SOL,CURSOR_SOL: unsigned(7 downto 0); 
    signal SEL_FIG: unsigned(1 downto 0);
    signal LD_CONT_SOL,DECR_CONT_SOL,END_SOL,LD_SOL,LD_CONT_FIG,DECR_CONT_FIG: std_logic;
    signal SEL_TRIA,SEL_CUAD,SEL_LINE,LD_LINE,LD_CUAD,LD_TRIA: std_logic;
    signal INCR_XPOS,INCR_YPOS,LD_XPOS,LD_YPOS,XLIM_CUAD,YLIM_CUAD,XLIM_LINE,YLIM_LINE: std_logic;
    signal CL_FIG: std_logic;
    
    
    signal draw_cuad_master, draw_tria_master: std_logic;
    



    component nono_graphics_cursor is
        port (
          clk,reset_l:  in std_logic;
      
        -- In
        UPDATE_CURSOR, TOGGLE_CURSOR, DONE_FIG: in std_logic;
        sol_out: in std_logic;
        cursorx, cursory: in unsigned (3 downto 0);
        -- Out
        XCOOR_int : out unsigned (7 downto 0);
        YCOOR_int : out unsigned (8 downto 0);
        COLOUR_CODE_int: out unsigned (2 downto 0);
        DRAW_CUAD_int, DRAW_TRIA_int: out std_logic;
        DONE_UPDATE, DONE_TOGGLE: out std_logic;
        addr_int: out unsigned (6 downto 0);
        rd_sol: out std_logic
          
        );
      end component;
	  
    
    signal sol_out_cursor: std_logic := '0';
	 


    signal COLOUR_CODE_cursor, colour_code_master: unsigned (2 downto 0);
    signal DRAW_CUAD_cursor, DRAW_TRIA_cursor: std_logic;

    signal addr_cursor: unsigned (6 downto 0);
    signal rd_sol_cursor: std_logic;
    signal xcoor_cursor, xcoor_master: unsigned (7 downto 0);
	 signal ycoor_cursor, ycoor_master: unsigned (8 downto 0);
	 signal slave: std_logic;

	 
	 

begin

    
	


    graphics_cursor: nono_graphics_cursor port map (
        clk => clk,
        reset_l => reset_l,

        update_cursor => update_cursor,
        TOGGLE_CURSOR => TOGGLE_CURSOR, 
        DONE_FIG => DONE_FIG,
        sol_out => sol_out_cursor,
        cursorx => CURSOR_POSX, 
        cursory => CURSOR_POSY,
        -- Out
        XCOOR_int => xcoor_cursor,
        YCOOR_int => ycoor_cursor,
        COLOUR_CODE_int => colour_code_cursor,
        DRAW_CUAD_int => draw_cuad_cursor, 
        DRAW_TRIA_int => draw_tria_cursor,
        DONE_UPDATE => done_update, 
        DONE_TOGGLE => done_toggle,
        addr_int => addr_cursor,
        rd_sol => rd_sol_cursor
        
    );
-----------------------
-- UNIDAD DE CONTROL --
-----------------------

-- proceso sincrono que actualiza el estado en flanco de reloj. Reset as?ncrono.
process (clk,RESET_L)
begin
  if RESET_L='0' then epres<=E_W8_INI;
    elsif clk'event and clk='1' then epres<=esig;
  end if;
end process;



process(epres,NONO_INI,OUT_CMD,END_SOL,DONE_DEL,DONE_FIG,CONT_FIG,XLIM_CUAD,YLIM_CUAD,XLIM_LINE,YLIM_LINE)
    begin
        case epres is
            when E_W8_INI => if(NONO_INI='1') then esig<=E_W8_CMD;
                             else esig<=E_W8_INI;
                             end if;
            when E_W8_CMD => if(OUT_CMD='1') then esig<=E_LD_SOL;
                             else esig<=E_W8_CMD;
                             end if;
            when E_LD_SOL => if(END_SOL='1') then esig<=E_W8_DEL;
                             else esig<=E_W8_CMD;
                             end if;
            when E_W8_DEL => if(DONE_DEL='1') then esig<=E_CL_FIG;
                             else esig<=E_W8_DEL;
                             end if;
            when E_CL_FIG => esig<=E_LD_POS;
            when E_LD_POS => esig<=E_DIB_FIG;
            when E_DIB_FIG => if(DONE_FIG='1') then 
                                if(CONT_FIG=to_unsigned(3,2)) then 
                                    if (XLIM_CUAD='0' or YLIM_CUAD='0') then esig<=E_LD_POS;
                                    else esig<=E_CL_FIG;
                                    end if;
                                elsif (CONT_FIG=to_unsigned(1,2)) then
                                    if (XLIM_LINE='0') then esig<=E_LD_POS;
                                    else esig<=E_CL_FIG;
                                    end if;
                                elsif (CONT_FIG=to_unsigned(2,2)) then
                                    if (YLIM_LINE='0') then esig<=E_LD_POS;
                                    else esig<=E_CL_FIG;
                                    end if;
                                else esig<=E_W8_CURSOR;
                                end if;
                            else esig<=E_DIB_FIG;
                            end if;
            when others => esig<=epres;
        end case;
        end process;


--seinales de control de estado

LD_CONT_SOL<= '1' when (epres=E_W8_INI and NONO_INI='1') else '0';

LD_SOL<='1' when (epres=E_LD_SOL) else '0';

DECR_CONT_SOL<='1' when (epres=E_LD_SOL and END_SOL='0') else '0';

DONE_BIT<='1' when (epres=E_LD_SOL) else '0';

DEL_SCREEN<='1' when (epres=E_LD_SOL) else '0';

LD_CONT_FIG<='1' when (epres=E_W8_DEL and DONE_DEL='1') else '0';

CL_FIG<='1' when ((epres=E_W8_DEL and DONE_DEL='1') or (epres=E_DIB_FIG  and DONE_FIG='1' and ((CONT_FIG=to_unsigned(1,2) and  XLIM_LINE='1') or (CONT_FIG=to_unsigned(2,2) and YLIM_LINE='1') or (CONT_FIG=to_unsigned(3,2) and  XLIM_CUAD='1' and YLIM_CUAD='1')))) else '0';

LD_XPOS<='1' when (epres=E_CL_FIG or (epres=E_DIB_FIG and DONE_FIG='1' and 
            (((CONT_FIG=to_unsigned(1,2) or CONT_FIG=to_unsigned(2,2)) and XLIM_LINE='1' and YLIM_LINE='0') or (CONT_FIG=to_unsigned(3,2) and XLIM_CUAD='1' and YLIM_CUAD='0')))) else '0';

LD_YPOS<='1' when (epres=E_CL_FIG) else '0';

LD_CUAD<='1' when (epres=E_CL_FIG and CONT_FIG=to_unsigned(3,2)) else '0';

LD_LINE<='1' when (epres=E_CL_FIG and (CONT_FIG=to_unsigned(1,2) or CONT_FIG=to_unsigned(2,2))) else '0';

LD_TRIA<='1' when (epres=E_CL_FIG and CONT_FIG=to_unsigned(0,2)) else '0';

DRAW_CUAD_master<='1' when (epres=E_DIB_FIG and CONT_FIG=to_unsigned(3,2) and DONE_FIG='0') else '0';

DRAW_LINE<='1' when (epres=E_DIB_FIG and (CONT_FIG=to_unsigned(1,2) or CONT_FIG=to_unsigned(2,2)) and DONE_FIG='0') else '0';

DRAW_TRIA_master<='1' when (epres=E_DIB_FIG and CONT_FIG=to_unsigned(0,2) and DONE_FIG='0') else '0';

VERTICAL<='1' when (epres=E_DIB_FIG and (CONT_FIG=to_unsigned(1,2)) and DONE_FIG='0') else '0';

DECR_CONT_FIG<='1' when (epres=E_DIB_FIG  and DONE_FIG='1' and ((CONT_FIG=to_unsigned(1,2) and  XLIM_LINE='1') or (CONT_FIG=to_unsigned(2,2) and  YLIM_LINE='1') or (CONT_FIG=to_unsigned(3,2) and  XLIM_CUAD='1' and YLIM_CUAD='1'))) else '0';

INCR_XPOS<='1' when (epres=E_DIB_FIG and DONE_FIG='1' and ((CONT_FIG=to_unsigned(1,2) and XLIM_LINE='0') or (CONT_FIG=to_unsigned(3,2) and XLIM_CUAD='0'))) else '0';

INCR_YPOS<='1' when (epres=E_DIB_FIG and DONE_FIG='1'and  ((CONT_FIG=to_unsigned(2,2) and YLIM_LINE='0') or (CONT_FIG=to_unsigned(3,2) and  XLIM_CUAD='1' and YLIM_CUAD='0'))) else '0';

slave <= '1' when (epres= E_W8_CURSOR) else '0';
nono_init_DONE <= '1' when (epres= E_W8_CURSOR) else '0';

-----------------------
-- UNIDAD DE PROCESO --
-----------------------

--CONSTANTES
XINI<=to_unsigned(13,8);
YINI<=to_unsigned(53,9);

draw_cuad<= draw_cuad_cursor when (slave='1') else draw_cuad_master;
draw_tria<= draw_tria_cursor when (slave='1') else draw_tria_master;

colour_code <= colour_code_cursor when (slave='1') else colour_code_master;
xcoor <= xcoor_cursor when (slave='1') else xcoor_master;
ycoor <= ycoor_cursor when (slave='1') else ycoor_master;



--CONTADOR SOL
process (clk,RESET_L)
begin
if (RESET_L='0') then CONT_SOL<=to_unsigned(1,8);
elsif clk'event and clk='1' then
if (LD_CONT_SOL='1') then CONT_SOL<=to_unsigned(99,8); 
elsif (DECR_CONT_SOL='1') then
 CONT_SOL<=CONT_SOL-1;
end if;
end if;
end process;
END_SOL<='1' when (CONT_SOL=to_unsigned(0,8)) else '0';

--CURSOR_SOL
CURSOR_SOL<=99-CONT_SOL;

--REGISTRO MAPA SOLUCION
process (clk,RESET_L)
begin
if (RESET_L='0') then SOL<=std_logic_vector(to_unsigned(0,100));
elsif clk'event and clk='1' then
if (LD_SOL='1') then SOL(to_integer(CURSOR_SOL))<=COMMAND(0);
elsif (rd_sol_cursor='1') then sol_out_cursor<=SOL(to_integer(addr_cursor));

end if;
end if;
end process;


--CONTADOR XPOS/YPOS INICIO
process (clk,RESET_L)
begin
if (RESET_L='0') then RXPOS<=to_unsigned(0,4); RYPOS<=to_unsigned(0,4);
elsif clk'event and clk='1' then
if (LD_XPOS='1') then RXPOS<=to_unsigned(0,4); 
elsif (INCR_XPOS='1') then
 RXPOS<=RXPOS+1;
end if;
if(LD_YPOS='1') then RYPOS<=to_unsigned(0,4);
elsif( INCR_YPOS='1') then
 RYPOS<=RYPOS+1;
end if;
end if;
end process;

--CONTADOR CONT_FIG
process (clk,RESET_L)
begin
if (RESET_L='0') then CONT_FIG<=to_unsigned(0,2);
elsif clk'event and clk='1' then
if (LD_CONT_FIG='1') then CONT_FIG<=to_unsigned(3,2); 
elsif (DECR_CONT_FIG='1') then
 CONT_FIG<=CONT_FIG-1;
end if;
end if;
end process;




--OPERACIONES XFIG
--xline=xini+xpos*4+xpos*17
XLINE<=XINI + ("00" & RXPOS & "00")+ ("0000" & RXPOS  ) +( RXPOS & "0000") ;
YLINE<=YINI +  ("000" & RYPOS  & "00") + ("00000" & RYPOS ) +("0" & RYPOS & "0000") ;

--XcuaD=XINI+XPOS*17+(XPOS+1)*4

XCUAD<=XINI +(  RXPOS & "0000")+ ("0000" & RXPOS  ) +("00" & (RXPOS+1) & "00") ;
YCUAD<=YINI + ("0" & RYPOS  & "0000") + ("00000" & RYPOS )+ ("000" & (RYPOS+1) & "00") ;



--BIESTABLE XFIG
process (clk,RESET_L)
begin
if (RESET_L='0') then RXLINE<=to_unsigned(0,8); RYLINE<=to_unsigned(0,9); RXCUAD<=to_unsigned(0,8); RYCUAD<=to_unsigned(0,9);
elsif clk'event and clk='1' then
    RXLINE<=XLINE; RYLINE<=YLINE; RXCUAD<=XCUAD; RYCUAD<=YCUAD;
end if;
end process;


--COMPARADOR LIM_CUAD,LIM_LINE
XLIM_CUAD<='1' when (RXPOS=9 or RXPOS>9) else '0';
YLIM_CUAD<='1' when (RYPOS=9 or RYPOS>9) else '0';
XLIM_LINE<='1' when (RXPOS=10 or RXPOS>10) else '0';
YLIM_LINE<='1' when (RYPOS=10 or RYPOS>10) else '0';


--BIESTABLE SEL_xxx
process (clk,RESET_L)
begin
if (RESET_L='0') then SEL_CUAD<='0';SEL_TRIA<='0';SEL_LINE<='0';
elsif clk'event and clk='1' then
if (CL_FIG='1') then SEL_CUAD<='0';SEL_TRIA<='0';SEL_LINE<='0';
elsif LD_CUAD='1' then SEL_CUAD<='1';
elsif LD_LINE='1' then SEL_LINE<='1';
elsif LD_TRIA='1' then SEL_TRIA<='1';
end if;
end if;
end process;





--MUX XCOOR/YCOOR/COLOUR CODE
SEL_FIG<="01" when SEL_TRIA='1' else
          "10" when SEL_CUAD='1' else
         "11" when SEL_LINE='1' else
	     "00" ;

XCOOR_master<=XINI+4 when SEL_FIG="01" else
       RXCUAD when SEL_FIG="10" else
       RXLINE when SEL_FIG="11" else
       to_unsigned(0,8);

YCOOR_master<=YINI+4 when SEL_FIG="01" else
       RYCUAD when SEL_FIG="10" else
       RYLINE when SEL_FIG="11" else
       to_unsigned(0,9);

COLOUR_CODE_master<="010" when SEL_FIG="01" else
        "111" when SEL_FIG="10" else
        "000" when SEL_FIG="11" else
        "110";


end arch_nono_graphics;