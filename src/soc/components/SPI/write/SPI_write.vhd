library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_unsigned.all;

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

type t_spi_w_state is (idle, bitsdata);

signal wstate, wstate_next : t_spi_w_state;

signal cnt, cnt_next : integer;

signal sck_sig: std_logic;


begin

combinatoire : process(wstate, start, cnt, sck_sig)
begin

case wstate is

	when idle =>

		MOSI <= '0';
		cnt_next <= 0;
		if start = '1' then
			wstate_next <= bitsdata;
		end if;

	when bitsdata =>
		MOSI <= data_in(cnt);
		
		if sck_sig ='1' then
			if cnt = M-1 then
				wstate_next <= idle;
			else
				cnt_next <= cnt + 1;
			end if;
		end if;

end case;

end process combinatoire;


registre: process(rst, clk, wstate)
begin

if rst = '1' then

	wstate <= idle;
	SCK <= '0';
	cnt <= 0; 
	sck_sig <= '0';

else

	if rising_edge(clk) then
		cnt <= cnt_next;
		wstate <= wstate_next;

		if wstate = bitsdata then
			SCK <= not(sck_sig);
			sck_sig <= not(sck_sig);
		else
			SCK <= '0';
		end if;
	end if;

end if;

end process registre;

end SPI_write_arch;

