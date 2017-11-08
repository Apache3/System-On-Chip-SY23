library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity timer is
	 Generic (BASE_ADDR	: integer := 16#2D#);
    Port (clk     : in   STD_LOGIC;
	        rst     : in   STD_LOGIC;
          addr    : in   STD_LOGIC_VECTOR (5 downto 0);
          ioread  : out  STD_LOGIC_VECTOR (7 downto 0);
          iowrite : in   STD_LOGIC_VECTOR (7 downto 0);
          rd      : in   STD_LOGIC;
          wr      : in   STD_LOGIC;
		      OC1A    : out  STD_LOGIC;
		      OC1Abar : out  STD_LOGIC);
end timer;

architecture timer_architecture of timer is

  component generic_divider is 
    Generic(N : positive := 4);
    Port (  clk     : in STD_LOGIC;
            rst     : in STD_LOGIC;
            division: in STD_LOGIC_VECTOR(N-1 downto 0);
            tc      : out STD_LOGIC
          );
  end component generic_divider;

  component power_clock_divider is 
    Generic(N : positive := 2);
    Port (  clk     : in std_logic;
            rst     : in std_logic;
            pow_div : in std_logic_vector(N-1 downto 0);
            clk_out : out std_logic
       );
  end component power_clock_divider;



constant OCR1A  : integer := BASE_ADDR ;
constant TCNT1  : integer := BASE_ADDR + 1;
constant TCCR1B : integer := BASE_ADDR + 2;
constant TCCR1A : integer := BASE_ADDR + 3;

signal reg_compA : STD_LOGIC_VECTOR (7 downto 0);
signal reg_count : STD_LOGIC_VECTOR (7 downto 0);
signal reg_ctrlA : STD_LOGIC_VECTOR (7 downto 0);
signal reg_ctrlB : STD_LOGIC_VECTOR (7 downto 0);

signal gen_div_out, pow_div_out : std_logic;



begin

  gen_divider : generic_divider generic map (N => 4)
    port map (
      clk => clk,
      rst => rst,
      division => reg_ctrlB(3 downto 0),
      tc => gen_div_out
      );

  pow_clk_div : power_clock_divider generic map (N => 2)
    port map(
      clk => clk,
      rst => rst,
      pow_div => reg_ctrlB(5 downto 4),
      clk_out => pow_div_out
      );


	

end timer_architecture;

