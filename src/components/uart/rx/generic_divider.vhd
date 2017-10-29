----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:53:59 09/29/2017 
-- Design Name: 
-- Module Name:    generic_freq_divider - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity generic_divider is
Generic(N : positive := 16);
Port (clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		division: in STD_LOGIC_VECTOR(N-1 downto 0);
		tc : out STD_LOGIC);
end generic_divider;

architecture Behavioral of generic_divider is

signal cpt : STD_LOGIC_VECTOR(N-1 downto 0);

begin
comptage : process(clk,rst,division)

begin
if rst = '1' then
	cpt <= (others => '0');
elsif rising_edge(clk) then
	if cpt < division then
		cpt <= cpt+1;
	else
		cpt<=(others =>'0');
	end if;
end if;

end process comptage;

retenue : process(cpt,division)
begin
if cpt = division then
	tc <= '1';
else
	tc <= '0';
end if;
end process retenue;

end Behavioral;

