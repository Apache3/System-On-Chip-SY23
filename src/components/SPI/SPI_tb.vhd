LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_unsigned.all;
 
 
ENTITY SPI_tb IS
END SPI_tb;
 
ARCHITECTURE behavior OF SPI_tb IS 
 
  component SPI
    Generic(M      : positive :=8);
    Port(  clk     : in std_logic;
           rst     : in std_logic;
           MISO    : in std_logic;
           start   : in std_logic;
           data_in : in std_logic_vector(M-1 downto 0);
           data_out: out std_logic_vector(M-1 downto 0);
           done    : out std_logic;    
           SCK     : out std_logic;
           MOSI    : out std_logic);     
  end component;
    
  --Inputs
   signal clk     : std_logic := '0';
   signal rst     : std_logic := '0';
   signal MISO    : std_logic := '0';
   signal start   : std_logic := '0';
   signal data_in : std_logic_vector(7 downto 0);

 	--Outputs
   signal data_out: std_logic_vector(7 downto 0);
   signal done    : std_logic;
   signal SCK     : std_logic := '0';
   signal MOSI    : std_logic := '0';

  --Clock period definitions
   constant clk_period : time := 20 ns;
   constant clk_div_val_period : time := 100 ns;

  --Data to send
   signal data_to_send : std_logic_vector (7 downto 0):= x"A5";
   signal cnt, cnt_next : integer := 0;
   signal mode_reception : integer := 0;
 

begin
 -- Instantiate the Unit Under Test (UUT)
 uut: SPI PORT MAP (
        clk => clk,
        rst => rst,
        MISO => MISO,
        start => start,
        data_in => data_in,
        data_out => data_out,
        done => done,
        SCK => SCK,
        MOSI => MOSI
      );

  --Clock process definitions
  clk_process :process
    begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  --Stimulus
  stim_proc: process
    begin		
    rst <= '1';
    wait for 100 ns;
    rst <= '0';

    data_in <= std_logic_vector(to_unsigned(11,8));
    wait for 20 ns;

    start <= '1';
    wait for 100 ns;
    start <= '0';

    wait for 90 ns;
    mode_reception <= 1;
    wait;
  end process;

  reception_miso : process(SCK, cnt, mode_reception)
  begin
    if falling_edge(SCK) AND (cnt < 8) AND (mode_reception = 1)then
      MISO <= data_to_send(cnt);
      cnt_next <= cnt + 1;
    end if;
  end process;

  registre : process(clk)
  begin
    if rising_edge(clk) then
      cnt <= cnt_next;
    end if;
  end process;

END;
