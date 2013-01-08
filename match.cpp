#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include<RcppArmadillo.h>

Rcpp::NumericMatrix placeBids(Rcpp::NumericMatrix benefits,
	Rcpp::NumericMatrix prices) {
	return NULL;
}

Rcpp::NumericMatrix assignWinners(Rcpp::NumericMatrix bids,
	Rcpp::NumericMatrix prices) {
	return NULL;
}

bool unmatched(Rcpp::NumericMatrix assignments) {
	return false;
}

RcppExport SEXP auction(SEXP benefits) {
	Rcpp::NumericMatrix inBenefits(benefits);

	int
		nrows = inBenefits.nrow(),
		ncols = inBenefits.ncol();

	arma::mat X(inBenefits.begin(), nrows, ncols, false);

	for(int i = 0; i < nrows; i++) {
		Rcpp::NumericVector rowi(inBenefits(i, Rcpp::_));
		for(int j = 0; j < ncols; j++)
			Rcpp::Rcout << rowi[j] << " ";
		Rcpp::Rcout << std::endl;
	}
	Rcpp::Rcout << arma::max(X, 0) << std::endl;
	return inBenefits;
}
