library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity usi is
	 Generic(BASE_ADDR	: integer := 16#0D#);
    Port ( clk        : in  STD_LOGIC;
           Rst        : in  STD_LOGIC;
           addr       : in  STD_LOGIC_VECTOR (5 downto 0);
           ioread     : out  STD_LOGIC_VECTOR (7 downto 0);
           iowrite    : in  STD_LOGIC_VECTOR (7 downto 0);
           wr         : in  STD_LOGIC;
           rd         : in  STD_LOGIC;
           SCK        : out  STD_LOGIC;
           MOSI       : out  STD_LOGIC;
           MISO       : in  STD_LOGIC);
end usi;

architecture usi_architecture of usi is

constant USICR : integer := BASE_ADDR ;           --adresse registre de donnees
constant USISR : integer := BASE_ADDR + 1;        --adresse registre de statut
constant USIDR : integer := BASE_ADDR + 2;        --adresse registre de controle

signal reg_usidr : STD_LOGIC_VECTOR (7 downto 0); --registre de donnees
signal reg_usisr : STD_LOGIC_VECTOR (7 downto 0); --registre de statut
signal reg_usicr : STD_LOGIC_VECTOR (7 downto 0); --registre de controle

component SPI is
  Generic(M      : positive :=8);
  Port(   clk     : in std_logic;
          rst     : in std_logic;
          MISO    : in std_logic;
          start   : in std_logic;
          data_in : in std_logic_vector(M-1 downto 0);
          data_out: out std_logic_vector(M-1 downto 0);
          done    : out std_logic;    
          SCK     : out std_logic;
          MOSI    : out std_logic);     
end component;

type t_usi_state is (idle, SPI_writing, register_writing, register_reading);
signal usi_state : t_usi_state;
signal MISO, start, done: std_logic;
signal data_in, data_out : std_logic_vector(7 downto 0);
signal machine_state : integer :=0;

begin

SPI_map: SPI generic map (M =>8)
port map( clk=>clk, 
          rst=>Rst, 
          MISO=>MISO,
          start=>start,
          data_in=>data_in,

          data_out=>data_out, 
          done=>done,
          SCK=>SCK,
          MOSI=>MOSI);

--combinatoire : process(rd, wr, done, reg_usicr, reg_usidr, reg_usisr, addr)
--begin
--  case usi_state is
--    when idle =>
--      machine_state <= 0;
--      if (rd='1') then
--        usi_state <= register_reading;
--      elsif (wr='1') then
--        usi_state <= register_writing;
--      elsif (to_integer(unsigned(reg_usidr)) /= 0) AND (reg_usicr(4)='1') then
--        usi_state <= SPI_writing;      
--        data_in <= reg_usidr; 
--      end if;

--    when SPI_writing =>
--      machine_state <= 1;
--      start <= '1';
--      if (done = '1') then
--        reg_usidr <= data_out;
--        usi_state <= idle;
--      end if ;

--    when register_reading =>
--      machine_state <= 2;
--      if to_integer(unsigned(addr)) = USIDR then
--        ioread <= reg_usidr;
--      elsif to_integer(unsigned(addr)) = USISR then
--        ioread <= reg_usisr;
--      elsif to_integer(unsigned(addr)) = USICR then
--        ioread <= reg_usicr;
--      end if ;
--      usi_state <= idle;

--    when register_writing =>
--      machine_state <= 3;
--      if to_integer(unsigned(addr)) = USIDR then
--        reg_usidr <= iowrite;
--      elsif to_integer(unsigned(addr)) = USISR then
--        reg_usisr <= iowrite;
--      elsif to_integer(unsigned(addr)) = USICR then
--        reg_usicr <= iowrite;
--      end if;
--      usi_state <= idle;
--  end case;

--end process combinatoire;

combinatoire : process(rd, wr, done, reg_usicr, reg_usidr, reg_usisr, addr)
begin
      
      --SPI write
      if (to_integer(unsigned(reg_usidr)) /= 0) AND (reg_usicr(4)='1') AND (reg_usicr(5)='0') AND (rd = '0') AND (wr = '0')then
        machine_state<=1;
        data_in <= reg_usidr; 
        start<='1';
      else
        machine_state<=0;
        start<='0';
      end if;

      --SPI done
      if (done = '1') then
        reg_usidr <= data_out;
        usi_state <= idle;
      end if ;

      --register read
      if (rd = '1') then
        if to_integer(unsigned(addr)) = USIDR then
          ioread <= reg_usidr;
        elsif to_integer(unsigned(addr)) = USISR then
          ioread <= reg_usisr;
        elsif to_integer(unsigned(addr)) = USICR then
          ioread <= reg_usicr;
        end if ;
      end if;

      --register write
      if (wr = '1') then
        if to_integer(unsigned(addr)) = USIDR then
          reg_usidr <= iowrite;
        elsif to_integer(unsigned(addr)) = USISR then
          reg_usisr <= iowrite;
        elsif to_integer(unsigned(addr)) = USICR then
          reg_usicr <= iowrite;
        end if;
      end if;

end process combinatoire;

registre : process(clk)
begin

end process registre;



end usi_architecture;

