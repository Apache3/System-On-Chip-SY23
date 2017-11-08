LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

 
ENTITY PWM_with_divider_tb IS
END PWM_with_divider_tb;
 
ARCHITECTURE behavior OF PWM_with_divider_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PWM_with_divider
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         clk_div_val : IN  std_logic_vector(15 downto 0);
         duty_cycle : IN  std_logic_vector(7 downto 0);
         pwm_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk_div_val : std_logic_vector(15 downto 0) := (others => '0');
   signal duty_cycle : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal pwm_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant clk_div_val_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PWM_with_divider PORT MAP (
          clk => clk,
          rst => rst,
          clk_div_val => clk_div_val,
          duty_cycle => duty_cycle,
          pwm_out => pwm_out
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   --clk_div_val_process :process
   --begin
		--clk_div_val <= '0';
		--wait for clk_div_val_period/2;
		--clk_div_val <= '1';
		--wait for clk_div_val_period/2;
   --end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 100 ns;	
		rst <= '0';
		clk_div_val <= "0000000000100111";
		duty_cycle <= "10000000";
		
      

      -- insert stimulus here 

      wait;
   end process;

END;
