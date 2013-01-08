#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include<RcppArmadillo.h>

using namespace std;
using namespace Rcpp;
using namespace arma;

NumericMatrix placeBids(mat benefits, mat prices) {
	return NULL;
}

NumericMatrix assignWinners(mat bids, mat prices) {
	return NULL;
}

bool unmatched(umat assignments) {
	// v may compete with R for memory (?)
	Row<uword> colMax = max(assignments);
	uword any = min(colMax);
	return any == 0;
}

// rows: bidders; cols: items (?)
RcppExport SEXP auction(SEXP benefits) {
	NumericMatrix inBenefits(benefits);

	int
		nBidders = inBenefits.nrow(),
		nItems = inBenefits.ncol();

	mat bene(inBenefits.begin(), nBidders, nItems, false);
	umat assi = zeros<umat>(nBidders, nItems);
	
	vec prices = zeros<vec>(nItems);

	int iterations = 0;
	while(unmatched(assi)) {
		assi(iterations, iterations) = 1;
		iterations++;
		Rcout << "iterations: " << iterations << endl;
		// assi = ones<mat>(nBidders, nItems);
	}
	
	return wrap(assi);
}
