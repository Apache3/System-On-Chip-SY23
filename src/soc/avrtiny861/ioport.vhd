library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;
use work.all;


entity ioport is
	 Generic (BASE_ADDR	: integer := 16#19#);
    Port ( clk     : in     STD_LOGIC;
	         rst     : in     STD_LOGIC;
           addr    : in     STD_LOGIC_VECTOR (5 downto 0);
           ioread  : out    STD_LOGIC_VECTOR (7 downto 0);
           iowrite : in     STD_LOGIC_VECTOR (7 downto 0);
           rd      : in     STD_LOGIC; --
           wr      : in     STD_LOGIC; --
		       ioport  : inout  STD_LOGIC_VECTOR (7 downto 0));
end ioport;

architecture ioport_architecture of ioport is

constant PORT_ADDR : integer := BASE_ADDR + 2;
constant DDR_ADDR : integer := BASE_ADDR + 1;
constant PIN_ADDR : integer := BASE_ADDR;

signal reg_port, reg_ddr, reg_pin : std_logic_vector(7 downto 0);


begin

  gestion_registres: process(clk, rst, reg_ddr,reg_pin,reg_port)
    variable int_addr : integer;
    variable rdwr : std_logic_vector(1 downto 0);

  begin
    if rst = '1' then 
      reg_port <= (others => '0');
      reg_ddr <= (others => '0');

    elsif rising_edge(clk) then
        rdwr := rd & wr;
        int_addr := to_integer(unsigned(addr));
        ioread <= (others => '0');
        reg_port <= reg_pin;

        if int_addr = PIN_ADDR then -- registre en lecture seule
          case rdwr is
            when "10" => 
              ioread <= reg_pin;
            when others =>
              null;
          end case;

        elsif int_addr = DDR_ADDR then 
          case rdwr is 
            when "10" =>
              ioread <= reg_ddr;

            when "01" =>
              reg_ddr <= iowrite;

            when others => 
              null;

          end case;

        elsif int_addr = PORT_ADDR then
          case rdwr is
            when "10" =>
              ioread <= reg_port;

            when "01" =>
              reg_port <= iowrite;

            when others => 
              null;

          end case;

        else
          ioread <= (others => '0');

        end if;
    	end if;
  end process gestion_registres;



  gestion_port : process(reg_ddr, ioport, reg_port, reg_pin)
  begin
    -- on écrite la valeur du port dans le registre de lecture du port
    for i in 0 to 7 loop

      if reg_ddr(i) = '1' then 
        --si le port est en écriture, on écrit le bit correspondant dans ioport
        ioport(i) <= reg_port(i);
        reg_pin(i) <= reg_port(i);
      else 
        --sinon on se met en haute impédance et on lit
        ioport(i) <= 'Z';
        reg_pin(i) <= ioport(i);
      end if;
    end loop;

  end process gestion_port;
end ioport_architecture;