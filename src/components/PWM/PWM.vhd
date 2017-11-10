library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_unsigned.all;


entity PWM is
Port( 	clk 		: in  STD_LOGIC;
		rst			: in  STD_LOGIC;
		duty_cycle	: in  STD_LOGIC_VECTOR(7 downto 0);
		mode		: in  STD_LOGIC_VECTOR(1 downto 0);
		counter	: out  STD_LOGIC_VECTOR(7 downto 0);
		pwm_out		: out STD_LOGIC );		 

end PWM;

architecture PWM_arch of PWM is

signal cpt, cpt_next : STD_LOGIC_VECTOR(7 downto 0);

begin

	--registre: process(cpt,cpt_next)
	--begin

	--end process registre;


	sync : process(clk,rst)
	begin
		if rst = '1' then
			cpt <= (others => '0');

		elsif rising_edge(clk) then
			cpt <= cpt_next;
			counter <= cpt_next;


		end if;		
	end process sync;	

	output : process(mode, duty_cycle, cpt)
	begin
		
		if duty_cycle > "00000000" then

			case mode is

				when "01"|"10" =>
					cpt_next <= cpt +1;

					if cpt = duty_cycle then
						pwm_out <= '0';
					elsif cpt = "00000000" then
						pwm_out <= '1';
					end if;

				when "11" =>
					cpt_next <= cpt +1;
					if cpt = duty_cycle then
						pwm_out <= '1';
					elsif cpt = "00000000" then
						pwm_out <= '0';
					end if;
				when others =>
					pwm_out <= '0';
					cpt_next <= (others => '0');
			end case;

		else
			cpt_next <= (others => '0');
			pwm_out <= '0';
		end if;

	end process output;

end PWM_arch;

