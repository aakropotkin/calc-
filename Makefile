.PHONY: all clean FORCE
.DEFAULT_GOAL = all

clean: FORCE
	$(MAKE) -C src clean

src/calc++:
	$(MAKE) -C src calc++

all: src/calc++
