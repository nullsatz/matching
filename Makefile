OBJS := match.o

ARCH := i386 # x86_64

#compiler/preprocessor options
INCS := -I. -I/Library/Frameworks/R.framework/Versions/2.15/Resources/include -I/Library/Frameworks/R.framework/Resources/include/$(ARCH) -I/Library/Frameworks/R.framework/Versions/2.15/Resources/library/Rcpp/include
PARAMS :=  -arch $(ARCH) -fPIC

#linker options
LD_PARAMS := -arch $(ARCH) -F/Library/Frameworks/R.framework/.. -framework R
LIBS :=   -L/Library/Frameworks/R.framework/Versions/2.15/Resources/library/Rcpp/lib/$(ARCH) -lRcpp

TARGETS := match.so

all: $(TARGETS) 

$(TARGETS): $(OBJS)
	g++ -shared $(LD_PARAMS) $(LIBS) $(OBJS) -o $@

$(OBJS): %.o: %.cpp
	g++ -c $(INCS) $(PARAMS) $^ -o $@

clean:
	rm -rf *o

.PHONY: all clean
