#!/usr/bin/Rscript

trial_match <- function() {
	return(data.frame(
		bidder=as.character(1:3),
		item=c('a', 'b'),
		benefit=runif(6),
	))
}

bid_phase <- function(benefits, prices) {
	bidders <- unique(benefits$bidder)
	bid_list <- list()
	nbids <- 0
	for(bidder in bidders) {
		bidder_benefits <- subset(benefits, benefits$bidder == bidder)

		values <- merge(bidder_benefits, prices, by='item')
		values$value <- values$benefit - values$price
		values <- values[order(values$value, decreasing=TRUE), ]

		if(nrow(values) < 1)
			next

		max1_value <- values[1, 'value']
		if(is.na(max1_value))
			next
		max_item <- values[1, 'item']

		if(nrow(values) < 2)
			max2_value <- 0.0
		else {
			max2_value <- values[2, 'value']
			if(is.na(max2_value))
				max2_price <- 0.0
		}
		nbids <- nbids + 1
		bid_list[[nbids]] <- data.frame(bidder=bidder, item=max_item,
			bid = max1_value - max2_value + 1.0)
	}
	if(nbids > 0)
		bids <- do.call('rbind', bid_list)
	else {
		bids <- data.frame(bidder=character(0), item=character(0),
			bid=numeric(0))
	}
	return(bids)
}

assignment_phase <- function(bids, prices, assignments) {
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
		prices$price <- ifelse(prices$item == item &
			prices$bidder == max_bidder, prices$price + max_bid, prices$price)
	}
	if(nwinners > 0)
		new_winners <- do.call('rbind', winners)
	else {
		new_winners <- data.frame(bidder=character(0), item=character(0),
			bid=numeric(0))
	}
	round_results <-list()
	round_results[['winners']] <- new_winners
	round_results[['prices']] <- prices
	return(new_winners)
}

match <- function(weights) {
}
