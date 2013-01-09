#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include<RcppArmadillo.h>

using namespace std;
using namespace Rcpp;
using namespace arma;

mat placeBids(mat benefits, vec prices) {
	uword
		nBidders = benefits.n_rows,
		nItems = benefits.n_cols;
	mat bids(nBidders, 3);
	bids(0, 1) = -1.0;
	for(int bidder = 0; bidder < nBidders; bidder++) {
		mat values = benefits.row(bidder) - prices;
		double maxValue = max(values); // change this to get the index
	}
}

void assignWinners(mat bids, mat prices, mat assignments) {
}

bool unmatched(umat assignments) {
	Row<uword> colMax = max(assignments);
	uword any = min(colMax);
	return any == 0;
}

// rows: bidders; cols: items
RcppExport SEXP auction(SEXP benefits) {
	NumericMatrix inBenefits(benefits);

	int
		nBidders = inBenefits.nrow(),
		nItems = inBenefits.ncol();

	mat bene(inBenefits.begin(), nBidders, nItems, false);
	mat bids(nBidders, nItems);
	umat assi(nBidders, nItems);
	vec prices(nItems);

	int iterations = 0;
	while(unmatched(assi)) {
		mat bids = placeBids(bene, prices, bids);
		Rcout << wrap(bids) << endl;
//		assignWinners(bids, prices, assi);
		iterations++;
		Rcout << "iterations: " << iterations << endl;
		assi = ones<mat>(nBidders, nItems);
	}
	
	return wrap(assi);
}
