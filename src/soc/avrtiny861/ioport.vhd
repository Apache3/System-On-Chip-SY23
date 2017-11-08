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

constant PORT_ADDR : integer := BASE_ADDR + 2; -- wr et rd
constant DDR_ADDR : integer := BASE_ADDR + 1; --0 = lecruree, 1 = ecriture
constant PIN_ADDR : integer := BASE_ADDR; -- lecture seule, valeur de ioport

signal reg_port,reg_ddr, reg_pin : std_logic_vector(7 downto 0);


begin

  synchro: process(clk, rst, reg_ddr)
    variable a_int : integer;
    variable rdwr : std_logic_vector(1 downto 0);

  begin



    if rst = '1' then
      
      reg_port <= (others => '0');
      reg_ddr <= (others => '0');
      reg_pin <= (others => '0');

    else if rising_edge(clk) then

        reg_pin <= ioport;
        rdwr := rd & wr;
        a_int := to_integer(unsigned(addr));
        ioread <= (others => '0');
        if (a_int = PIN_ADDR) then

          case(rdwr) is
            when "01" => 
              ioread <= reg_pin;
            when others =>
              null;
          end case;
          ioread <= ioport;
        end if;

        if (a_int = DDR_ADDR) then
          case rdwr is 
            when "01" =>

              ioread <= reg_ddr;

            when "10" =>
              
              reg_ddr <= iowrite;

            when others => 
            null;

          end case;
        end if;

        if (a_int = PORT_ADDR) then

          case rdwr is
            when "10" => --read
              ioread <= reg_port;
            when "01" => --write
              for i in 7 downto 0 loop
                if reg_ddr(i) = '1' then --authorization to write
                  reg_port(i) <= iowrite(i);

                else 
                  reg_port(i) <= 'Z';
                end if;

              end loop;
            when others => null;
          end case;
        end if;
        

    	end if;

    end if;
  end process synchro;



  output : process(reg_ddr)
  begin
    reg_pin <= ioport;
    for i in 0 to 7 loop
      if reg_ddr(i) = '1' then
        ioport(i) <= reg_port(i);
      end if;
    end loop;

  end process output;
end ioport_architecture;

