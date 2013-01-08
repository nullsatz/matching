#!/usr/bin/Rscript

dyn.load('match.so')
q <- data.frame(u=1:3)
z <- .Call('auction', q)
