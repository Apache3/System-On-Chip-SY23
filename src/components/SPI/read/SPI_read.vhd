library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_unsigned.all;

entity SPI_read is
	Generic(M      : positive :=8);
	Port( clk      : in  std_logic;
		  rst 	   : in  std_logic;
		  MISO 	   : in  std_logic;
		  CS	   : in  std_logic;
		  SCK      : in  std_logic;
		  data_out : out std_logic_vector(M-1 downto 0);
		  done     : out std_logic);		 

end SPI_read;

architecture SPI_read_arch of SPI_read is

type t_spi_r_state is (idle, bitsdata, dataread);

signal rstate, rstate_next : t_spi_r_state;

signal cnt, cnt_next : integer;

--signal 



begin

combinatoire : process(rstate, CS, cnt, SCK)
begin

case rstate is
	
	when idle =>
		data_out <= (others => '0');
		done <= '0';
		cnt_next <= 0;

		if CS = '0' then 
			rstate_next <= bitsdata;
		end if;

	when bitsdata =>

		--if SCK = '1' then
		if rising_edge(SCK) then

			data_out(cnt) <= MISO;
			if cnt = M-1 then 
				rstate_next <= dataread;
			else
				cnt_next <= cnt + 1;
			end if;

		end if;

	when dataread =>
		done <= '1';
		rstate_next <= idle;

end case;

end process combinatoire;

registre : process(clk, rst)
begin

if rst = '1' then

	rstate <= idle;
	cnt <= 0;

else

	if rising_edge(clk) then

		rstate <= rstate_next;
		cnt <= cnt_next;

	end if;

end if; 

end process registre;

end SPI_read_arch;

