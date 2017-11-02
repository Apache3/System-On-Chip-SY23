LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY SPI_write_tb IS
END SPI_write_tb;
 
ARCHITECTURE behavior OF SPI_write_tb IS 
 
    COMPONENT SPI_write
      Generic(M       : positive :=8);
      Port(   clk     : in std_logic;
              rst     : in std_logic;
              start   : in std_logic;
              data_in : in std_logic_vector(M-1 downto 0);
              CS      : out std_logic;
              SCK     : out std_logic;
              MOSI    : out std_logic);  
    END COMPONENT;
    

   --Inputs
   signal clk     : std_logic := '0';
   signal rst     : std_logic := '0';
   signal start   : std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
  signal CS   : std_logic;
  signal SCK  : std_logic;
  signal MOSI : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant clk_div_val_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SPI_write PORT MAP (
          clk => clk,
          rst => rst,
          start => start,
          data_in => data_in,
          CS => CS,
          SCK => SCK,
          MOSI => MOSI
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
		rst <= '1';
    wait for 100 ns;	

    data_in <= x"5A";
		rst <= '0';
    wait for clk_period*2;

    start <= '1';
    wait for clk_period*4;
    start <= '0';

   wait;
   end process;

END;
