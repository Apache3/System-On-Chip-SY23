library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rs232_rx is
Port(clk_div_val : in STD_LOGIC_VECTOR(15 downto 0);
		data : out STD_LOGIC_VECTOR(7 downto 0);
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		rx : in STD_LOGIC;
		rx_done : out STD_LOGIC);
		
end rs232_rx;

architecture rs232_rx_arch of rs232_rx is

component generic_divider is
Generic(N : positive := 16);
Port (clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		division: in STD_LOGIC_VECTOR(N-1 downto 0);
		tc : out STD_LOGIC);
end component generic_divider;

type t_rxstate is (listening, reading, writing);

signal rxstate, rxstate_next : t_rxstate;

signal div_rst, clk_div: std_logic;

signal rxdata, rxdata_next : std_logic_vector(7 downto 0);

signal bitcnt, bitcnt_next : unsigned (3 downto 0);



begin

diviseur: generic_divider generic map (N =>16)
port map( clk => clk, rst => div_rst, division => clk_div_val, tc => clk_div);

registre: process(clk,rst)
begin

	if rst = '1' then
		rxstate <= listening;
		bitcnt <= (others => '0');
		div_rst <='1';
		rxdata <= (others => '0');
	else
		div_rst <= '0';

		if rising_edge(clk) then

			rxstate <= rxstate_next;
			bitcnt <= bitcnt_next;
			rxdata <= rxdata_next;
			--data <= rxdata;

		end if;
	end if;

end process registre;

combinatoire: process(rx,clk_div, rxstate)
begin

case rxstate is
	when listening =>

		bitcnt_next <= (others => '0');
		rxdata_next <= (others => '0');

		if rx = '0' and clk_div = '1' then -- si on voit le bit de start

			rxstate_next <= reading; -- on passe en mode lecture de donnée 

		end if;

	when reading =>

		--if clk_div = '1' then --and rising_edge(clk) then
		if rising_edge(clk_div) then --and rising_edge(clk) then

			rxdata_next <= rx & rxdata_next(7 downto 1);

			if bitcnt = 7 then
				rxstate_next <= writing;
			else
				bitcnt_next <= bitcnt + 1;
			end if;

		end if;

	when writing =>
			
			rxstate_next <= listening;


end case;

end process combinatoire;

sortie: process(rxstate,rxdata)
begin

data <= rxdata;
rx_done <= '0';

case rxstate is

	when listening =>
	when reading =>
	when writing =>
		rx_done <= '1';
end case;

end process sortie;


end rs232_rx_arch;

