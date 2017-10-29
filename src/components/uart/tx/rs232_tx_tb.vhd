--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:22:10 10/06/2017
-- Design Name:   
-- Module Name:   /home/uvs/xilinx/Apache Babar/TP1/rs232c/rs232_tx_tb.vhd
-- Project Name:  rs232c
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RS232_TX
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.numeric_std.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY rs232_tx_tb IS
END rs232_tx_tb;


ARCHITECTURE behavior OF rs232_tx_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
constant bauds : integer := 115200;
constant sysclk : real := 50.0e6;
constant N : integer := integer(sysclk/real(bauds));
constant DIVTX : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(N, 16));
 
    COMPONENT RS232_TX
	 
	 
    PORT(
         clk_div : IN  std_logic_vector(15 downto 0);
         data : IN  std_logic_vector(7 downto 0);
         start : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         empty : OUT  std_logic;
         TX : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk_div : std_logic_vector(15 downto 0) := (others => '0');
   signal data : std_logic_vector(7 downto 0) := (others => '0');
   signal start : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal empty : std_logic;
   signal TX : std_logic;

   -- Clock period definitions
   constant clk_div_period : time := 100 ns;
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RS232_TX PORT MAP (
          clk_div => clk_div,
          data => data,
          start => start,
          rst => rst,
          clk => clk,
          empty => empty,
          TX => TX
        );

   -- Clock process definitions

 
   clk_process :process
   begin
		clk_div <= DIVTX;
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      --wait for 100 ns;	
      rst <= '1';
      wait for clk_div_period*10;

      --h 0x68
		--e 0x65
		--l 0x6C
		--o 0x6F
		--space	0x20
		--w 0x77
		--r 0x72
		--d 0x64
		--! 0x21
		
		--wait for 100 ns;
		--h
		data <= x"68";
		rst <= '0';
		wait for 45 us;
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
		--e
		data <= x"65";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
		--l
		data <= x"6C";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
		
		--l
		data <= x"6C";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
		
		--o
		data <= x"6F";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
		
		--space
		data <= x"20";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
		
		--w
		data <= x"77";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
		
		--o
		data <= x"6F";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
		
		--r
		data <= x"72";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
		
		--l
		data <= x"6C";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
		
		--d
		data <= x"64";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
				
		--!
		data <= x"21";
		start <='1';
		wait for 100 ns;
		start <='0';
		wait for 1 ms;
		
      wait;
   end process;

END;
