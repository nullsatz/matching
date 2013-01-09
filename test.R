#!/usr/bin/Rscript

dyn.load('match.so')
q <- matrix(runif(6), 3)
z <- .Call('auction', q)
