----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:42:51 10/20/2017 
-- Design Name: 
-- Module Name:    SPI - SPI_arch 
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
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
--arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SPI_write is
Generic(M      : positive :=8);
Port(  clk     : in std_logic;
	   rst     : in std_logic;
	   start   : in std_logic;
	   data_in : in std_logic_vector(M-1 downto 0);
	   CS      : out std_logic;
	   SCK     : out std_logic;
	   MOSI    : out std_logic);		 

end SPI_write;

architecture SPI_write_arch of SPI_write is


--component generic_divider is
--Generic(N : positive := 16);
--Port (clk : in STD_LOGIC;
--		rst : in STD_LOGIC;
--		division: in STD_LOGIC_VECTOR(N-1 downto 0);
--		tc : out STD_LOGIC);
--end component generic_divider;

type t_spi_w_state is (idle, bitsdata);

signal wstate, wstate_next : t_spi_w_state;

signal cnt, cnt_next : unsigned(M-1 downto 0);

signal sck_sig : std_logic;


begin

--diviseur: generic_divider generic map (N =>16)
--	port map( clk => clk, rst => div_rst, division => clk_div_val, tc => clk_div);

combinatoire : process(wstate, start, cnt, sck_sig)
begin

case wstate is

	when idle =>

		MOSI <= '0';
		cnt_next <= to_unsigned(0,M);
		CS <= '1';
		if start = '1' then
			wstate_next <= bitsdata;
		end if;

	when bitsdata =>
		CS <= '0';
		MOSI <= data_in(to_integer(cnt));
		
		if sck_sig ='1' then
			if cnt = M-1 then
				wstate_next <= idle;
			else
				cnt_next <= cnt + 1;
			end if;
		end if;

		--if cnt = M then
		--	wstate_next <= idle;
		--end if;



end case;

end process combinatoire;


registre: process(rst, clk, wstate)
begin

if rst = '1' then

	wstate <= idle;
	--MOSI <= '0';
	--CS <= '0';
	SCK <= '0';
	cnt <= to_unsigned(0,M);
	sck_sig <= '0';

else
	if rising_edge(clk) then
		cnt <= cnt_next;
		wstate <= wstate_next;
		SCK <= '1';
		if wstate = bitsdata then
			sck_sig <= not(sck_sig);
			SCK <= sck_sig;
		end if;
	end if;

end if;


end process registre;


end SPI_write_arch;

