library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PWM_with_divider is
Port (	clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		clk_div_val: in STD_LOGIC_VECTOR(15 downto 0);
		duty_cycle: in STD_LOGIC_VECTOR(7 downto 0);
		pwm_out: out STD_LOGIC
	 );
end PWM_with_divider;

architecture Behavioral of PWM_with_divider is

	component PWM
		Port( clk: in STD_LOGIC;
		rst: in STD_LOGIC;
		clk_div: in STD_LOGIC;
		duty_cycle: in STD_LOGIC_VECTOR(7 downto 0);
		pwm_out: out STD_LOGIC 
			
		);
	end component PWM;

	component generic_divider is
	Generic(N : positive := 16);
	Port (clk : in STD_LOGIC;
			rst : in STD_LOGIC;
			division: in STD_LOGIC_VECTOR(N-1 downto 0);
			tc : out STD_LOGIC);
	end component generic_divider;

	signal clk_div : STD_LOGIC;

begin

	pwm_component : PWM port map(
		clk => clk,
		rst => rst,
		clk_div => clk_div,
		duty_cycle => duty_cycle,
		pwm_out => pwm_out
	);

	diviseur: generic_divider generic map (N =>16)
	port map( 	
		clk => clk,
		rst => rst, 
		division => clk_div_val, 
		tc => clk_div
	);

end Behavioral;

