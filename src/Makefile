# This Makefile is designed to be simple and readable.  It does not
# aim at portability.  It requires GNU Make.

BISON = bison
CXX   = c++
FLEX  = flex
RM    = rm -f

all: calc++

%.cc %.hh: %.yy
	$(BISON) $(BISONFLAGS) -o $*.cc $<

%.cc: %.ll
	$(FLEX) $(FLEXFLAGS) -o$@ $<

%.o: %.cc
	$(CXX) $(CXXFLAGS) -c -o$@ $<

calc++: calc++.o driver.o parser.o scanner.o
	$(CXX) -o $@ $^

calc++.o: parser.hh
parser.o: parser.hh
scanner.o: parser.hh

clean:
	$(RM) calc++ *.o parser.hh parser.cc scanner.cc
