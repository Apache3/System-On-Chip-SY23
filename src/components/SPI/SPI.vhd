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
signal serial_state, serial_state_next : t_SerialClock_state; 
signal cnt, cnt_next : integer;
signal sck_sig, sck_sig_next, sck_start : std_logic; 
signal sck_cnt : integer;
signal machine_signal : integer;
signal machine_serial_signal : integer;
signal pause_cnt, pause_cnt_next : integer;

begin

combinatoire : process(state, start, cnt, sck_sig, pause_cnt)
begin
	case state is
		when idle =>
			machine_signal <= 0;
			data_out <= (others => '0');
			done <= '0';
			cnt_next <= 0;
			MOSI <= '0';
			cnt_next <= 0;
			pause_cnt_next <= 0;
			serial_state_next <= idle;
			if start = '1' then
				state_next <= writing;
			end if;

		when writing =>
			serial_state_next <= pulsing;
			machine_signal <= 1;
			MOSI <= data_in(cnt);
			cnt_next <= cnt + 1;
			if cnt = M-1 then
				state_next <= pause;
			end if;

		when pause =>
			machine_signal <= 2;
			serial_state_next <= idle;
			pause_cnt_next <= pause_cnt + 1;
			if (pause_cnt > 3) then
				cnt_next <= 0; 
				state_next <= reading;
			end if;

		when reading =>
			serial_state_next <= pulsing;
			machine_signal <= 3;
			if rising_edge(sck_sig) then
				data_out(cnt) <= MISO;
				if cnt = M-1 then 
					state_next <= idle;
					done <= '1';
				else
					cnt_next <= cnt + 1;
				end if;
			end if;
	end case;
end process combinatoire;


SerialClock : process(serial_state, clk)
begin
	case serial_state is
		when idle =>
			machine_serial_signal <= 0;
			SCK <= '0';
			sck_sig_next <= '0';

		when pulsing =>
			machine_serial_signal <= 1;
			SCK <= sck_sig;
			sck_sig_next <= not(sck_sig);
	end case;
end process SerialClock;


registre: process(rst, clk)
begin
	if rst = '1' then
		state <= idle;
		--SCK <= '0';
		cnt <= 0; 
		sck_sig <= '0';
		--sck_sig_next <= not(sck_sig);
		serial_state <= idle;
	else
		if rising_edge(clk) then
			serial_state <= serial_state_next;
			cnt <= cnt_next;
			state <= state_next;
			pause_cnt <= pause_cnt_next;
			sck_sig <= sck_sig_next;
		end if;
	end if;
end process registre;


end SPI_arch;