OUTPUT=extreme-print

$(OUTPUT): $(OUTPUT)-with-header
	ruby remove-section-header.rb $^ $@

$(OUTPUT)-with-header:extreme.o
	ld -s -x -N -o $@ $^

.PHONY: clean

clean:
	rm -f $(OUTPUT)* *.o *.S

.S.o:
	clang -m64 -c $^ -o $@

extreme.S: template.rb source.txt
	ruby template.rb $(TEMP_ARGS) > $@
