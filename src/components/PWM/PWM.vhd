----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:42:51 10/20/2017 
-- Design Name: 
-- Module Name:    PWM - PWM_arch 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
--arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PWM is
Port( clk: in STD_LOGIC;
		rst: in STD_LOGIC;
		clk_div_val: in STD_LOGIC_VECTOR(15 downto 0);
		duty_cycle: in STD_LOGIC_VECTOR(7 downto 0);
		pwm_out: out STD_LOGIC );		 

end PWM;

architecture PWM_arch of PWM is


component generic_divider is
Generic(N : positive := 16);
Port (clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		division: in STD_LOGIC_VECTOR(N-1 downto 0);
		tc : out STD_LOGIC);
end component generic_divider;

signal clk_div, div_rst : STD_LOGIC;
signal cpt : STD_LOGIC_VECTOR(7 downto 0);

begin

diviseur: generic_divider generic map (N =>16)
									port map( clk => clk, rst => div_rst, division => clk_div_val, tc => clk_div);

pwm: process(clk, clk_div,cpt, rst, duty_cycle)
begin
if rst = '1' then
	cpt <= (others =>'0');
	pwm_out <='0';
	div_rst <= '1';
else
	div_rst <= '0';
	
	if rising_edge(clk) and clk_div = '1' then
	cpt <= cpt + 1;
	
	end if;

	if (cpt > duty_cycle ) then
		pwm_out <= '0';
	else 
		pwm_out <='1';
	end if;
	
end if;
 
 


end process pwm;



end PWM_arch;

