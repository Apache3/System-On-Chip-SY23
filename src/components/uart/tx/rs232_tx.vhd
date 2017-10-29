----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:09:02 09/29/2017 
-- Design Name: 
-- Module Name:    RS232_TX - RS232_TX_arch 
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

entity RS232_TX is
Port(clk_div : in STD_LOGIC_VECTOR(15 downto 0);
		data : in STD_LOGIC_VECTOR(7 downto 0);
		start : in STD_LOGIC;
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		empty : out STD_LOGIC;
		TX : out STD_LOGIC);
		
end RS232_TX;

architecture RS232_TX_arch of RS232_TX is

signal tx_state: STD_LOGIC_VECTOR(1 downto 0);-- := "00";
signal tx_state_next: STD_LOGIC_VECTOR(1 downto 0);-- := "00";

signal bitcnt: UNSIGNED(3 downto 0);-- :="0000";
signal bitcnt_next: UNSIGNED(3 downto 0);-- :="0000";

signal data_next: STD_LOGIC_VECTOR(7 downto 0);

signal div_cpt: UNSIGNED(15 downto 0);
signal div_cpt_next : UNSIGNED(15 downto 0);

signal tc : STD_LOGIC;


begin
--begin process combination
combination: process(rst,start,clk, tc)
begin
--Reset actif à 1

if rising_edge(rst) then
	tx_state_next <= "00";
	bitcnt_next <= "0000";
	TX <= '1';
	empty <= '0';
	div_cpt_next <=(others =>'0');
else

	
	if( rising_edge(clk) ) then

		case tx_state is
		when "00" =>
			TX <= '1';
			empty <= '1';
			bitcnt_next <= "0000";
			data_next <= data;
			if start = '1' then
				tx_state_next <= "01";
			end if;


		when "01" =>
			TX <= '0';
			empty <= '0';
			tx_state_next <= "10";


		when "10" =>
			empty <= '0';
			
			if tc = '1' then 
				TX <= data_next(0);
				data_next <= '0' & data_next(7 downto 1);
				bitcnt_next <= bitcnt + 1;
			end if;


			if ( bitcnt > 7 ) then
				tx_state_next <= "11";
			end if;

			

		when "11" =>
			TX <= '1';
			empty <= '0';
			tx_state_next <= "00";

		when others =>
			tx_state_next <= "00";

		end case;

	end if;
		--if (div_cpt >=)
end if;



end process combination;

etat_suivant: process(clk,div_cpt,tc)
begin

if rising_edge(tc) then

	tx_state <= tx_state_next;

end if;


if rising_edge(clk) then

	
	--div_cpt <= div_cpt_next;
	bitcnt <= bitcnt_next;

	if (div_cpt < UNSIGNED(clk_div) ) then

		div_cpt <= div_cpt + 1;
	else

		div_cpt<=(others =>'0');

	end if;
	
end if;

end process etat_suivant;

diviseur: process(div_cpt)
begin

if (div_cpt = UNSIGNED(clk_div)) then

	tc <= '1';

else 

	tc <= '0';

end if;

end process diviseur;


end RS232_TX_arch;

