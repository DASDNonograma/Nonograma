library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-- A 128x8 single-port RAM in VHDL
entity SUBMOD_RAM is
port(
    clk: in std_logic; -- Clock input
    reset_l: in std_logic; -- Reset input

    addr: in unsigned(6 downto 0); -- Address to write/read RAM
    data_in: in std_logic; -- Data to write into RAM
    WR: in std_logic; -- Write enable 
    RD: in std_logic; -- Read enable 
 
  data_out: out std_logic -- Data output of RAM
);
end SUBMOD_RAM;

architecture SUBMOD_RAM_arch of SUBMOD_RAM is


type ram_array is array (0 to 127 ) of std_logic;

signal data: ram_array :=(
    '0','0','0','0',-- 0x00: 
    '0','0','0','0',-- 0x04: 
    '0','0','0','0',-- 0x08:
    '0','0','0','0',-- 0x0C:
    '0','0','0','0',-- 0x10:
    '0','0','0','0',-- 0x14:
    '0','0','0','0',-- 0x18:
    '0','0','0','0',-- 0x1C:
    '0','0','0','0',-- 0x20:
    '0','0','0','0',-- 0x24:
    '0','0','0','0',-- 0x28:
    '0','0','0','0',-- 0x2C:
    '0','0','0','0',-- 0x30:
    '0','0','0','0',-- 0x34:
    '0','0','0','0',-- 0x38:
    '0','0','0','0',-- 0x3C:
    '0','0','0','0',-- 0x40:
    '0','0','0','0',-- 0x44:
    '0','0','0','0',-- 0x48:
    '0','0','0','0',-- 0x4C:
    '0','0','0','0',-- 0x50:
    '0','0','0','0',-- 0x54:
    '0','0','0','0',-- 0x58:
    '0','0','0','0',-- 0x5C:
    '0','0','0','0',-- 0x60:
    '0','0','0','0',-- 0x64:
    '0','0','0','0',-- 0x68:
    '0','0','0','0',-- 0x6C:
    '0','0','0','0',-- 0x70:
    '0','0','0','0',-- 0x74:
    '0','0','0','0',-- 0x78:
    '0','0','0','0'--  
   ); 
begin
process(clk, reset_l)
begin
 
    if (reset_l = '0') then -- when reset = 0, reset the RAM
        data <= (others => '0');
        data_out <= '0';
    elsif (clk'event and clk = '1') then  
        if (RD = '1' and WR = '1') then -- invierte el bit almacenado
            data(to_integer(addr)) <= not data(to_integer(addr));            
        elsif (WR = '1') then 
            data(to_integer(addr)) <= data_in; 
        elsif (RD = '1') then  
            data_out <= data(to_integer(addr)); 
        end if;
    end if;
end process;

 
end SUBMOD_RAM_arch;
