library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity rs232_tx is
Port(	clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		start : in STD_LOGIC;
		data : in STD_LOGIC_VECTOR(7 downto 0);
		clk_div_val : STD_LOGIC_VECTOR(7 downto 0);
		empty : out STD_LOGIC;
		TX : out STD_LOGIC);		
end rs232_tx;

architecture rs232_tx_arch of rs232_tx is

component generic_divider is
Generic(N : positive := 16);
Port (clk : in STD_LOGIC;
		rst : in STD_LOGIC;
		division: in STD_LOGIC_VECTOR(N-1 downto 0);
		tc : out STD_LOGIC);
end component generic_divider;

type t_txstate is (idle, bit_start, writing, bit_stop);

signal txstate, txstate_next : t_txstate;

signal data_next, data_buffer, data_buffer_next : STD_LOGIC_VECTOR(7 downto 0);

signal div_rst, div_rst_next, clk_div, empty_next, TX_next : std_logic;

signal bitcpt, bitcpt_next : STD_LOGIC_VECTOR(7 downto 0);

begin


diviseur: generic_divider generic map (N =>16)
port map( clk => clk, rst => div_rst, division => clk_div_val, tc => clk_div);


combinatoire: process(tx, clk_div, txstate)
begin

case txstate is
	when idle =>
		TX_next <= '1';
		empty_next <= '1';
		div_rst_next <= '1';
		bitcpt_next <= '0';

		if start = '1' then
			txstate_next <= bit_start;
		end if;

	when bit_start =>
		TX_next <= '0';
		empty_next <= '0';
		div_rst_next <= '0';
		bitcpt_next <= '0';
		data_buffer_next <= data;

		if rising_edge(clk_div) then
			txstate_next <= writing;
		end if;

	when writing =>
		if rising_edge(clk_div) && bitcpt < 7 then 
			TX_next <= data_buffer & '1'
			data_buffer_next <= srl(data_buffer);
			bitcpt_next <= bitcpt +1;

		elsif  bitcpt = 7 
			txstate_next <= bit_stop;
		end if;

	when bit_stop =>
		TX_next <= '1';
		empty_next <= '0';
		div_rst_next <= '0';

		if rising_edge(clk_div) then
			txstate_next <= idle;
		end if;

end case;
end process combinatoire;


registre: process(clk,rst)
begin

	if rst = '1' then
		txstate <= idle;
		div_rst <= '1';
		TX <= '1';
	else
		if rising_edge(clk) then
			TX <= TX_next;
			empty <= empty_next;
			div_rst <= div_rst_next;
			bitcpt <= bitcpt_next;
			txstate <= txstate_next;
			data_buffer <= data_buffer_next;
		end if;
	end if;
end process registre;


sortie: process(txstate,txdata)
begin

data <= txdata;

case txstate is
	when idle =>
	when writing =>
end case;

end process sortie;




end rs232_tx_arch;