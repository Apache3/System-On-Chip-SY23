library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_unsigned.all;


entity SPI is
	Generic(M      : positive :=8);
	Port(  clk     : in std_logic;
		   rst     : in std_logic;
		   MISO	   : in std_logic;
		   start   : in std_logic;
		   data_in : in std_logic_vector(M-1 downto 0);
		   data_out: out std_logic_vector(M-1 downto 0);
		   done    : out std_logic;		 
		   SCK     : out std_logic;
		   MOSI    : out std_logic);		 
end SPI;

architecture SPI_arch of SPI is

type t_spi_state is (idle, writing, pause, reading);
type t_SerialClock_state is (idle, pulsing);
signal state, state_next : t_spi_state;
signal cnt, cnt_next : integer;
signal sck_sig, sck_sig_next, sck_state : std_logic; 
signal sck_cnt : integer;
signal machine_signal : integer;
signal machine_serial_signal : integer;
signal pause_cnt, pause_cnt_next : integer;

begin

combinatoire : process(state, start, cnt, sck_sig, pause_cnt, MISO)
begin
	case state is
		when idle =>
			machine_signal <= 0;
			data_out <= (others => '0');
			done <= '0';
			cnt_next <= 0;
			MOSI <= '0';
			pause_cnt_next <= 0;
			sck_state <= '0';

			if start = '1' then
				state_next <= writing;
			end if;

		when writing =>
			--serial_state_next <= pulsing;
			machine_signal <= 1;
			sck_state <= '1';
			if sck_sig = '1' then
				
				MOSI <= data_in(cnt);
				if cnt = M-1  then

					state_next <= pause;
				else 
					cnt_next <= cnt + 1;

				end if;
			end if;

		when pause =>
			MOSI <= '0';
			machine_signal <= 2;
			sck_state <= '0';
			pause_cnt_next <= pause_cnt + 1;

			if (pause_cnt > 3) then
				state_next <= reading;
			end if;

		when reading =>
			sck_state <= '1';
			machine_signal <= 3;
			if sck_sig ='1' then
				data_out(cnt) <= MISO;
				if cnt = 0 then 
					state_next <= idle;
					sck_state <= '0';
					done <= '1';
				else
					cnt_next <= cnt - 1;
				end if;
			end if;
	end case;
end process combinatoire;


SerialClock : process(clk, sck_state,sck_sig)
begin
	--case serial_state is
	--	when idle =>
	--		machine_serial_signal <= 0;
	--		SCK <= '0';
	--		sck_sig_next <= '0';

	--	when pulsing =>
	--		machine_serial_signal <= 1;
	--		SCK <= sck_sig;
	--		sck_sig_next <= not(sck_sig);
	--end case;
	if (sck_state = '0') then
		machine_serial_signal <= 0;
		--sck_sig <= '0';
		sck_sig_next <= '0';
	else
		machine_serial_signal <= 1;
		--SCK <= sck_sig;
		sck_sig_next <= not(sck_sig);
	end if;
end process SerialClock;


registre: process(rst, clk, sck_sig)
begin
	if rst = '1' then
		state <= idle;
		
		SCK <= '0';
		cnt <= 0; 
		sck_sig <= '0';
		--sck_sig_next <= not(sck_sig);
	else
		SCK <= sck_sig;
		if rising_edge(clk) then
			cnt <= cnt_next;
			state <= state_next;
			pause_cnt <= pause_cnt_next;
			sck_sig <= sck_sig_next;

		end if;
	end if;
end process registre;


end SPI_arch;