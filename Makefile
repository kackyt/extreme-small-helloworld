OUTPUT=extreme-print

$(OUTPUT): extreme.o
	ld -s -x -N -o $@ $^

.S.o:
	clang -m64 -c $^ -o $@

extreme.S: template.rb source.txt
	ruby template.rb > $@
