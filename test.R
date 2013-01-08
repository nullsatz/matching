#!/usr/bin/Rscript

dyn.load('match.so')
q <- matrix(runif(25), 5)
q[4, ] <- NA
print(q)
z <- .Call('auction', q)
