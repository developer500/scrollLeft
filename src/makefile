
targetnm = scrollleft
outfold = ../build
astyle = /Users/stuartadamson/Documents/zx81/pretty6502/pretty6502
ASTYLEFLAGS = -ml -m4 -o9

$(outfold)/$(targetnm).P: $(targetnm).asm *.asm
	z80asm +zx81 -O$(outfold) $^

$(targetnm).asm: $(targetnm).asm.m4
	m4 $< > $@

.PHONY: clean
clean:
	rm -f $(outfold)/*.o $(outfold)/*.bin $(outfold)/*.P $(outfold)/*.err

style : 
	$(astyle) $(ASTYLEFLAGS) $(targetnm).asm.m4 $(targetnm).asm.m4
	$(astyle) $(ASTYLEFLAGS) randchars.asm randchars.asm
	$(astyle) $(ASTYLEFLAGS) defs.asm defs.asm
