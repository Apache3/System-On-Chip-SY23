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

	sync : process(clk,rst)
	begin
		if rst = '1' then
			cpt <= (others => '0');

		elsif rising_edge(clk) then--on change l'état du compteur interne et de la sortie
			cpt <= cpt_next;
			counter <= cpt_next;


		end if;		
	end process sync;	

	output : process(mode, duty_cycle, cpt)
	begin
		cpt_next <= cpt +1;
				
		case mode is -- changements en fonction de COM1A

			when "01"|"10" => --mise à 0 à la comparaison, à 1 au retour à 0

				if cpt = duty_cycle then
					pwm_out <= '0';
				elsif cpt = "00000000" then
					pwm_out <= '1';
				end if;

			when "11" => --mise à 1 à la comparaison, à 0 au retour à 0
				if cpt = "00000000" then
					pwm_out <= '0';
				elsif cpt = duty_cycle then
					pwm_out <= '1';
				end if;
			when others => -- sinon on réinitialise le compteur
				pwm_out <= '0';
				cpt_next <= (others => '0');
		end case;

	end process output;

end PWM_arch;

