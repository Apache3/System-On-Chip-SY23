library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_unsigned.all;


entity PWM is
Port( 	clk 		: in  STD_LOGIC;
		rst			: in  STD_LOGIC;
		clk_div		: in  STD_LOGIC;
		duty_cycle	: in  STD_LOGIC_VECTOR(7 downto 0);
		pwm_out		: out STD_LOGIC );		 

end PWM;

architecture PWM_arch of PWM is

signal cpt : STD_LOGIC_VECTOR(7 downto 0);

begin

	pwm: process(clk, clk_div,cpt, rst, duty_cycle)
	begin
		if rst = '1' then
			cpt <= (others =>'0');
			pwm_out <='0';
		else
			if rising_edge(clk) and clk_div = '1' then
	
				cpt <= cpt + 1;
			
			end if;

			if (cpt > duty_cycle ) then
				pwm_out <= '0';
			else 
				pwm_out <='1';
			end if;
			
		end if;

	end process pwm;

end PWM_arch;

