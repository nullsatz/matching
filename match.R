#!/usr/bin/Rscript

trial_match <- function() {
	return(data.frame(
		bidder=as.character(1:3),
		item=c('a', 'b'),
		value=runif(6),
	))
}

bid_phase <- function(benefits, prices) {
	bidders <- unique(benefits$bidder)
	bid_list <- list()
	nbids <- 0
	for(bidder in bidders) {
		bidder_benefits <- subset(benefits, benefits$bidder == bidder)
		if(nrow(bidder_benefits) < 1)
			next
		bidder_benefits <- bidder_benefits[order(bidder_benefits$price,
			decreasing=TRUE), ]

		max1_price <- bidder_benefits[1, 'price']
		if(is.na(max1_price))
			next
		max_item <- bidder_benefits[1, 'item']

		if(nrow(bidder_benefits) < 2)
			max2_price <- 0.0
		else {
			max2_price <- controls[2, 'price']
			if(is.na(max2_price))
				max2_price <- 0.0
		}
		nbids <- nbids + 1
		bid_list[[nbids]] <- data.frame(bidder=bidder, item=max_item,
			bid = max1_price - max2_price + 1.0)
	}
	if(nbids > 0)
		bids <- do.call('rbind', bid.list)
	else {
		bids <- data.frame(bidder=character(0), item=character(0),
			bid=numeric(0))
	}
	return(bids)
}

assignment_phase <- function(assignments, bids) {
	items <- unique(bids$item)
	winners <- list()
	nwinners <- 0
	for(item in items) {
		item_bids <- subset(bids, !is.na(bids$bid) & bids$item == item)

		if(nrow(item_bids) < 1)
			next

		item_bids <- item_bids[order(item_bids$bid, decreasing=TRUE), ]
		max_bid <- item_bids[1, 'bid']

		nwinners <- nwinners + 1
		max_bidder <- item_bids[1, 'bidder']

		winners[[nwinners]] <- data.frame(bidder=max_bidder, item=item,
			bid=max_bid)
	}
	if(nwinners > 0)
		new_winners <- do.call('rbind', winners)
	else {
		new_winners <- data.frame(bidder=character(0), item=character(0),
			bid=numeric(0))
	}
	return(new_winners)
}

match <- function(weights) {
}
