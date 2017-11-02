LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY SPI_read_tb IS
END SPI_read_tb;
 
ARCHITECTURE behavior OF SPI_read_tb IS 
 
 
    COMPONENT SPI_read
      Generic(M      : positive :=8);
      Port( clk      : in  std_logic;
            rst      : in  std_logic;
            MISO     : in  std_logic;
            CS       : in  std_logic;
            SCK      : in  std_logic;
            data_out : out std_logic_vector(M-1 downto 0);
            done     : out std_logic);  
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal MISO : std_logic := '0';
   signal CS : std_logic := '1';
   signal SCK : std_logic := '0';


 	--Outputs

  signal data_out : std_logic_vector(7 downto 0);
  signal done : std_logic;

  --signal for sck

--  signal sck_sig : 
   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant clk_div_val_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: SPI_read PORT MAP (
          clk => clk,
          rst => rst,
          done => done,
          data_out => data_out,
          CS => CS,
          SCK => SCK,
          MISO => MISO
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
		rst <= '1';
    wait for 100 ns;	


		rst <= '0';

    CS <= '0';
    wait for clk_period*3;
    SCK <= '1';
    wait for clk_period;
    SCK <= '0';
    MISO <= '1';
    wait for clk_period;

    SCK <= '1';
    wait for clk_period;
    SCK <= '0';
    MISO <= '0';
    wait for clk_period;

    SCK <= '1';
    wait for clk_period;
    SCK <= '0';
    MISO <= '1';
    wait for clk_period;

    SCK <= '1';
    wait for clk_period;
    SCK <= '0';
    wait for clk_period;

    SCK <= '1';
    wait for clk_period;
    SCK <= '0';
    MISO <= '0';
    wait for clk_period;

    SCK <= '1';
    wait for clk_period;
    SCK <= '0';
    MISO <= '1';
    wait for clk_period;

    SCK <= '1';
    wait for clk_period;
    SCK <= '0';
    MISO <= '0';
    wait for clk_period;

    SCK <= '1';
    wait for clk_period;
    SCK <= '0';





      wait;
   end process;

  -- skc_process : process
  -- begin

  --  if CS = '0' and rising_edge(clk) then
  --    SCK <= not(SCK);
  --  end if;
  --end process;

END;
