CC=ghdl
PROG=generic_divider
SRC=$(PROG).vhd
VCD=$(PROG).vcd
SRCTB=$(PROG)_tb.vhd
ENTITE=$(PROG)_tb
OPTIONS= --ieee=synopsys -fexplicit
AOPTIONS= -Wc,-m32 -Wa,--32
EOPTIONS= -Wa,--32 -Wl,-m32
STOPTIME=10us
	
all: compile simule execute view

test:
	$(CC) -s $(OPTIONS) $(SRC)
	
compile:
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRC)
	$(CC) -s $(OPTIONS) $(SRCTB)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRCTB)

simule:
	$(CC) -e $(EOPTIONS) $(OPTIONS) $(ENTITE)
	
execute:
	$(CC) -r $(OPTIONS) $(ENTITE) --vcd=$(VCD) --stop-time=$(STOPTIME)
	
view:
	gtkwave $(VCD)
	
clean:
	$(CC) --clean
	rm  $(VCD)
	rm work-obj93.cf
