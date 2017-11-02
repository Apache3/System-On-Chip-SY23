CC=ghdl
PROG=rs232_tx
SRC=$(PROG).vhd
VCD=$(PROG).vcd
SRCTB=$(PROG)_tb.vhd
ENTITE=$(PROG)_tb
OPTIONS= --ieee=synopsys -fexplicit
AOPTIONS= -Wc,-m32 -Wa,--32
EOPTIONS= -Wa,--32 -Wl,-m32
STOPTIME=10ms
	
all:
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRC)
	$(CC) -a $(AOPTIONS) $(OPTIONS) $(SRCTB)
	$(CC) -e $(EOPTIONS) $(OPTIONS) $(ENTITE)
	$(CC) -r $(OPTIONS) $(ENTITE) --vcd=$(VCD) --stop-time=$(STOPTIME)
	view
	
view:
	gtkwave $(VCD)
	
clean:
	$(CC) --clean
	rm  $(VCD) *.cf
