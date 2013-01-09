#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include<RcppArmadillo.h>

using namespace std;
using namespace Rcpp;
using namespace arma;

mat placeBids(mat benefits, rowvec prices) {
	uword
		nBidders = benefits.n_rows,
		nItems = benefits.n_cols,
		maxIdx;

	double
		max1Value, max2Value;

	mat bids(nBidders, 2);

	for(int bidder = 0; bidder < nBidders; bidder++) {
		rowvec values = benefits.row(bidder) - prices;
		double max1Value = values.max(maxIdx);
		values(maxIdx) = 0.0;
		double max2Value = max(values);
		bids(bidder, 0) = maxIdx;
		bids(bidder, 1) = max1Value - max2Value + 1.0;
	}
	return bids;
}

vec getMaxItemBid(uword item, mat bids) {
	uword
		nBidders = bids.n_rows,
		maxIdx = nBidders;
	double
		currentBid = 0.0, maxBid = -1.0;

	for(int bidder = 0; bidder < nBidders; bidder++) {
		if(bids(bidder, 0) == item) {
			currentBid = bids(bidder, 1);
			if(currentBid > maxBid) {
				maxIdx = bidder;
				maxBid = currentBid;
			}
		}
	}
	vec winner(2);
	winner(0) = maxIdx;
	winner(1) = maxBid;
	return winner;
}

void assignWinners(mat bids, rowvec prices, umat & assignments) {
	uword
		winnerIdx = 0,
		nItems = prices.size();
	double winningBid;

	for(int item = 0; item < nItems; item++) {
		vec winner = getMaxItemBid(item, bids);
		winnerIdx = winner(0);
		winningBid = winner(1);
		if(winningBid < 0.0)
			continue;
		prices(item) += winningBid;
		assignments.col(item).fill(0);
		assignments(winnerIdx, item) = 1;
	}
	Rcout << assignments << endl;
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
	mat bids;
	umat assi(nBidders, nItems);
	rowvec prices(nItems);

	Rcout << bene << endl;

	while(unmatched(assi)) {
		bids = placeBids(bene, prices);

		Rcout << bids << endl;
		
		assignWinners(bids, prices, assi);

		Rcout << assi << endl;

		break;
	}
	return wrap(assi);
}
