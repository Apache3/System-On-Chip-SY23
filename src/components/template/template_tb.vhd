LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY template_tb IS
END template_tb;
 
ARCHITECTURE behavior OF template_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT template
    PORT(
        );
    END COMPONENT;
    

   --Inputs

 	--Outputs

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant clk_div_val_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: template PORT MAP (
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
 
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.

      -- insert stimulus here 

      wait;
   end process;

END;
