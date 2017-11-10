
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



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

retenue : process(clk,rst,cpt,division)
begin
if cpt = division then
	if division > 0 then

		tc <= '1';
	else
		tc <= clk;
	end if;
else
	tc <= '0';
end if;
end process retenue;

end Behavioral;