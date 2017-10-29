--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:22:10 10/06/2017
-- Design Name:   
-- Module Name:   /home/uvs/xilinx/Apache Babar/TP1/rs232c/rs232_rx_tb.vhd
-- Project Name:  rs232c
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: rs232_rx
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
 
ENTITY rs232_rx_tb IS
END rs232_rx_tb;


ARCHITECTURE behavior OF rs232_rx_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
constant bauds : integer := 115200;
constant sysclk : real := 50.0e6;
constant N : integer := integer(sysclk/real(bauds));
constant DIVTX : std_logic_vector(15 downto 0) := std_logic_vector(to_unsigned(N, 16));
 
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
   constant clk_period : time := 100 ns;
 
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
		--clk_div <= DIVTX;
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

      clk_div_val <= "0000000000001000";

      rst <= '0';

      wait for 100 ns;
      rx <= '0';
      wait for 1 ms;
      rx <= '1';

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
		
		
      wait;
   end process;

END;
