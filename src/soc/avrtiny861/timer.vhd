library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.all;
use ieee.std_logic_unsigned.all;


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


  component pwm is
    Port( clk       : in  STD_LOGIC;
          rst       : in  STD_LOGIC;
          clk_div   : in  STD_LOGIC;
          duty_cycle: in  STD_LOGIC_VECTOR(7 downto 0);
          pwm_out   : out STD_LOGIC );
  end component pwm;



constant OCR1A  : integer := BASE_ADDR ; --registre de comparaison
constant TCNT1  : integer := BASE_ADDR + 1; --valeur du compteur
constant TCCR1B : integer := BASE_ADDR + 2; --registre controle B
constant TCCR1A : integer := BASE_ADDR + 3; --registre controle A

--register of comparaison
signal reg_compA : STD_LOGIC_VECTOR (7 downto 0);
--counter
signal reg_count : STD_LOGIC_VECTOR (7 downto 0); 

signal reg_ctrlA : STD_LOGIC_VECTOR (7 downto 0); 
-- b7,b6: mod fct comp A :
  --00 Z sur sorite 
  --01 0 à comparaison , 1 si registre compteur à 0 (oc et ocbar)
  --10 0 à comparaison, 1 si registre compteur à 0 (oc
  --11 1 à comparaison , 1 si registre compteur à 1 (oc et ocbar)
-- 
-- b5,b4: mod fct comp B :comme b7 et b6 mais osef
-- b3: force sortie A 0: 1:
-- b2:force sortie B 
-- b1:pwm A 
-- b0:pwm B


signal reg_ctrlB : STD_LOGIC_VECTOR (7 downto 0);
-- b7:inversion OC1A et OC1Abar
-- b6: reset diviseur
-- b5, b4: power div
-- b3, b2, b1, b0: valeur division 

signal gen_div_out    : std_logic; --sortie diviseur
signal pow_div_out    : std_logic; --sortie diviseur de puissance
signal pwm_clk        : std_logic; --entrée timer du pwm
signal pwm_out        : std_logic; --sortie pwm
signal div_on_bar     : std_logic; --signal inverse de l'activation du diviseur
signal pow_div_on_bar : std_logic; --signal inverse de l'activation du diviseur de puissance


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

  pwm_comp : pwm 
  port map(
    clk => clk,
    rst => rst,
    clk_div => pwm_clk,
    duty_cycle => "10000000",
    pwm_out => pwm_out
    );

  gestion_registres : process(clk,rst,addr,iowrite,rd,wr)  
  variable int_addr : integer;
  variable rdwr : std_logic_vector(1 downto 0);
  begin
    if rst ='1' then

    elsif rising_edge(clk) then
      int_addr := conv_integer(addr);
      rdwr := rd & wr;
      
      if int_addr = OCR1A then
        case rdwr is 
          when "10" =>
            reg_compA <= iowrite;

          when "01" =>
            ioread <= reg_compA;
          when others =>
            null;

        end case;

      elsif int_addr = TCNT1 then
        case rdwr is 
          when "10" =>
            reg_count <= iowrite;

          when "01" =>
            ioread <= reg_count;
          when others =>
            null;

        end case;        

      elsif int_addr = TCCR1A then
          case rdwr is 
          when "10" =>
            reg_ctrlA <= iowrite;

          when "01" =>
            ioread <= reg_ctrlA;
          when others =>
            null;

        end case;

      elsif int_addr = TCCR1B then
        case rdwr is 
          when "10" =>
            reg_ctrlB <= iowrite;

          when "01" =>
            ioread <= reg_ctrlB;
          when others =>
            null;

        end case;

      end if;
    end if;

  end process gestion_registres;	

end timer_architecture;

