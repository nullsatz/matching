#!/usr/bin/Rscript

args <- as.numeric(commandArgs(trailingOnly=T))
nBidders <- args[1]
nItems <- args[2]

dyn.load('match.so')
q <- matrix(runif(nBidders * nItems), nBidders)
system.time(z <- .Call('auction', q))
