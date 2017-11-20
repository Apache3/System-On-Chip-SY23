CC=ghdl
PROG=SPI
SRC=$(PROG).vhd
VCD=$(PROG).vcd
SRCTB=$(PROG)_tb.vhd
ENTITE=$(PROG)_tb
OPTIONS= --ieee=synopsys -fexplicit
STOPTIME=3us
	
all: compile simule execute view

test:
	$(CC) -s $(OPTIONS) $(SRC)
	
compile:
	$(CC) -a $(OPTIONS) $(SRC)
	$(CC) -s $(OPTIONS) $(SRCTB)
	$(CC) -a $(OPTIONS) $(SRCTB)

simule:
	$(CC) -e $(OPTIONS) $(ENTITE)
	
execute:
	$(CC) -r $(OPTIONS) $(ENTITE) --vcd=$(VCD) --stop-time=$(STOPTIME)
	
view:
	gtkwave $(VCD)
	
clean:
	$(CC) --clean
	rm work-obj93.cf
	rm  $(VCD)
