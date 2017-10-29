----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:09:02 09/29/2017 
-- Design Name: 
-- Module Name:    rs232_rx - rs232_rx_arch 
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
--use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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
		data <= (others => '0');
		rx_done <= '0';
	else
		div_rst <= '0';

		if rising_edge(clk) then

			rxstate <= rxstate_next;
			bitcnt <= bitcnt_next;
			rxdata <= rxdata_next;

		end if;
	end if;

end process registre;

combinatoire: process(rx,clk_div, rxstate)
begin

case rxstate is
	when listening =>

		rx_done <= '0';

		if falling_edge(rx) and clk_div = '1' then -- si on voit le bit de start

			rxstate_next <= reading; -- on passe en mode lecture de donnée 

		end if;

	when reading =>

		if clk_div = '1' then --and rising_edge(clk) then

			rxdata_next <= rxdata_next(6 downto 0) & rx;

			if bitcnt = 7 then
				rxstate_next <= writing;
			else
				bitcnt_next <= bitcnt + 1;
			end if;

		end if;

	when writing =>
		if clk_div = '1' then
			data  <= rxdata;
			rx_done <= '1';
			rxstate_next <= listening;
		end if;


end case;

end process combinatoire;


end rs232_rx_arch;

