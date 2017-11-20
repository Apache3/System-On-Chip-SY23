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

signal cpt, cpt_next, div_comp : std_logic_vector( (2**N) -1 downto 0);

begin

--décode la puissance de 2 en nombre à compter	
decoder : process(pow_div)
variable bit_nb : integer;--bit correspondant à la puissance de 2
begin
	bit_nb := to_integer(unsigned(pow_div));
	div_comp <= (others => '0');
	if bit_nb > 0 then
		div_comp(bit_nb-1 downto 0) <= (others => '1'); --on comptera jusqu'à 2^n - 1
	end if;

end process decoder;

counter : process(clk,rst, cpt, div_comp)
begin

	if rst = '1' then
		clk_out <= '0';
	else
		if cpt = div_comp  then -- si on a compté jusqu'à 2^n - 1
			cpt_next <= (others => '0');-- on remet le compteur à 0
			if cpt > 0 then -- si on divise par au moins 2 
				clk_out <= '1'; 
			
			else	--sinon on branche directement clk sur la sortie
				clk_out <= clk;
			end if;
		else
			cpt_next <= cpt + '1';
			clk_out <= '0';
		end if;
	end if;

end process counter;



synchro : process(clk, rst)
begin

	if rst = '1' then
		cpt <= (others => '0');

	else if rising_edge(clk) then

		cpt <= cpt_next;

		end if;
	end if;

end process synchro;

end Behavioral;

