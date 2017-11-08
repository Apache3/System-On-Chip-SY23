LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY power_clock_divider_tb IS
END power_clock_divider_tb;
 
ARCHITECTURE behavior OF power_clock_divider_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT power_clock_divider
    Generic(N : positive := 4);
    Port (  clk : in std_logic;
            rst : in std_logic;
            pow_div : in std_logic_vector(N-1 downto 0);
            clk_out : out std_logic
           );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal pow_div : std_logic_vector(3 downto 0);

 	--Outputs

  signal clk_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
   constant clk_div_val_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: power_clock_divider PORT MAP (
          clk => clk,
          rst => rst,
          pow_div => pow_div,
          clk_out => clk_out
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

      pow_div <= "0000";
      wait for 100 ns;

      rst <= '0';

      pow_div <= "0001";
      wait for 1000 ns;


      pow_div <= "0010";
      wait for 1000 ns;

      pow_div <= "0011";
      wait for 1000 ns;

      pow_div <= "0100";
      wait for 1000 ns;

      wait;
   end process;

END;
