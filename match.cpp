#include<stdio.h>
#include<stdlib.h>
#include<string.h>

#include<Rcpp.h>
using namespace Rcpp;

DataFrame placeBids(DataFrame benefits, DataFrame prices) {
	return NULL;
}

DataFrame assignWinners(DataFrame bids, DataFrame prices) {
	return NULL;
}

bool unmatched(DataFrame assignments) {
	return false;
}

RcppExport SEXP auction(SEXP benefits) {
	DataFrame inBenefits(benefits);
	int nrows = inBenefits.nrows();

	Rcout << "n_rows = " << nrows << std::endl;

	std::vector<double> u = Rcpp::as< std::vector<double> >(inBenefits["u"]);

	for(int i = 0; i < nrows; i++) {
		std::ostringstream convert;
		convert << u[i];
		Rcout << convert.str() << std::endl;

	}

	return inBenefits;
}
