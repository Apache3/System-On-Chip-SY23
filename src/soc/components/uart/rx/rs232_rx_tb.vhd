LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
ENTITY rs232_rx_tb IS
END rs232_rx_tb;


ARCHITECTURE behavior OF rs232_rx_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
constant bauds : integer := 115200;
constant sysclk : real := 50.0e6;
constant N : integer := integer(sysclk/real(bauds));
constant DIVRX : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(N, 16));
 
    COMPONENT rs232_rx
	 
	 
		Port(clk_div_val : in STD_LOGIC_VECTOR(15 downto 0);
		data : out STD_LOGIC_VECTOR(7 downto 0);
		rst : in STD_LOGIC;
		clk : in STD_LOGIC;
		rx : in STD_LOGIC;
		rx_done : out STD_LOGIC);
		
    END COMPONENT;
    

   --Inputs
   signal clk_div_val : std_logic_vector(15 downto 0) := (others => '0');
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal rx : std_logic := '1';

 	--Outputs
   --signal rx : std_logic;
   signal data : std_logic_vector(7 downto 0);
   signal rx_done : std_logic;

   -- Clock period definitions
   constant clk_div_period : time := 100 ns;
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: rs232_rx PORT MAP (
          clk_div_val => clk_div_val,
          data => data,
          rst => rst,
          clk => clk,
          rx_done => rx_done,
          rx => rx
        );

   -- Clock process definitions

 
   clk_process :process
   begin
		clk_div_val <= DIVRX;
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
      wait for clk_period*1000;


      rst <= '0';

      wait for 10 us;
      rx <= '0'; --start bit
      wait for clk_div_period;
      
      rx <= '1'; --bit 1
      wait for clk_div_period;

      rx <= '0';--bit 2
      wait for clk_div_period;

      rx <= '1';--bit 3
      wait for clk_div_period;

      rx <= '0';--bit 4
      wait for clk_div_period;

      rx <= '1';--bit 5
      wait for clk_div_period;

      rx <= '0';--bit 6
      wait for clk_div_period;

      rx <= '1';--bit 7
      wait for clk_div_period;

      rx <= '0';--bit 8
      wait for clk_div_period;

      rx <= '1';
		
      wait;
   end process;

END;
