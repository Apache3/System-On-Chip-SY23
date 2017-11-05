library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use work.all;

entity power_clock_divider is
Generic(N : positive := 4);
Port (	clk : in std_logic;
		rst : in std_logic;
		pow_div : in std_logic_vector(N-1 downto 0);
		clk_out : out std_logic
	 );
end power_clock_divider;

architecture Behavioral of power_clock_divider is

signal cpt, cpt_next, clk_div : integer;

begin


counter : process(cpt, clk_div,pow_div)
begin

	clk_div <= (2**to_integer(unsigned(pow_div)) ) - 1;

	if cpt = clk_div then
		clk_out <= '1';
		cpt_next <= 0;
	else
		cpt_next <= cpt +1;
		clk_out <= '0';
	end if;

end process counter;

synchro : process(clk, rst)
begin

	if rst = '1' then

		cpt <= 0;

	else if rising_edge(clk) then

		cpt <= cpt_next;

		end if;
	end if;

end process synchro;

end Behavioral;

