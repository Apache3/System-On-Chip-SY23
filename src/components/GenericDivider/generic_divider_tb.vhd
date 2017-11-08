
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY generic_divider_tb IS
END generic_divider_tb;
 
ARCHITECTURE behavior OF generic_divider_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT generic_divider
    Generic(N : positive := 16);
    Port (
          clk : in STD_LOGIC;
          rst : in STD_LOGIC;
          division: in STD_LOGIC_VECTOR(N-1 downto 0);
          tc : out STD_LOGIC
          );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '1';
   signal division : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal tc : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: generic_divider PORT MAP (
          clk => clk,
          rst => rst,
          division => division,
          tc => tc
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

      division <= "0000000000001000";
      wait for 100 ns;	
  		rst <= '0';	
	
      wait;
   end process;

END;
