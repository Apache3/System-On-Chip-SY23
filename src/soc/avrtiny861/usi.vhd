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

constant USIDR : integer := BASE_ADDR ;           --adresse registre de donnees
constant USISR : integer := BASE_ADDR + 1;        --adresse registre de statut
constant USICR : integer := BASE_ADDR + 2;        --adresse registre de controle

signal reg_usidr : STD_LOGIC_VECTOR (7 downto 0); --registre de donnees
signal reg_usisr : STD_LOGIC_VECTOR (7 downto 0); --registre de statut
signal reg_usicr : STD_LOGIC_VECTOR (7 downto 0); --registre de controle

component SPI_read is
  Generic(M        : positive :=8);
  Port(   clk      : in std_logic;
          rst      : in std_logic;
          MISO     : in std_logic;
          CS       : in std_logic;
          SCK      : in std_logic;
          data_out : out std_logic_vector(M-1 downto 0);
          done     : out std_logic);
end component SPI_read;

component SPI_write is
  Generic(M        : positive :=8);
  Port(   clk      : in std_logic;
          rst      : in std_logic;
          start    : in std_logic;
          data_in  : in std_logic_vector(M-1 downto 0);
          CS       : out std_logic;
          SCK      : out std_logic;
          MOSI     : out std_logic);
end component SPI_write;

type t_usi_state is (idle, SPI_reading, SPI_writing, register_writing, register_reading);
signal usi_state : t_usi_state;
signal start_SPI_write, start_SPI_read, CS_SPI_read, CS_SPI_write, SCK_SPI_read, SCK_SPI_write, SPI_read_done : std_logic;
signal data_in_SPI, data_out_SPI : std_logic_vector(7 downto 0);

begin

SPI_read_map: SPI_read generic map (M =>8)
port map( clk=>clk, 
          rst=>Rst, 
          CS=>CS_SPI_read, 
          SCK=>SCK_SPI_read, 
          MISO=>MISO,

          data_out=>data_out_SPI , 
          done=>SPI_read_done);

SPI_write_map: SPI_write generic map (M =>8)
port map( clk=>clk, 
          rst=>Rst, 
          start=>start_SPI_write, 
          data_in=>data_in_SPI ,

          CS=>CS_SPI_write , 
          SCK=>SCK_SPI_write);

combinatoire : process(rd, wr)
begin
  case usi_state is
    when idle =>
      if (rd='1') then
        usi_state <= register_reading;
        else if (wr='1') then
          usi_state <= register_writing;
        end if;
      end if;

    when SPI_reading =>

    when SPI_writing =>

    when register_reading =>

    when register_writing =>

  end case;

end process combinatoire;

registre : process(clk)
begin

end process registre;



end usi_architecture;

