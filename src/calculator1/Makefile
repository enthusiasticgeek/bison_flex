file=calculator1
all:
	flex $(file).l
	bison -d $(file).y
	gcc -o $(file) $(file).tab.c lex.yy.c -lfl -lm
