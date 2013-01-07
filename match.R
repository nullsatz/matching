#!/usr/bin/Rscript

trial_match <- function() {
	trial <- data.frame(bidder=character(12), item=character(12),
		benefit=runif(12), stringsAsFactors=FALSE)
	i <- 0
	for(bidder in as.character(1:4)) {
		for(item in c('a', 'b', 'c')) {
			i <- i + 1
			trial[i, 'bidder'] <- bidder
			trial[i, 'item'] <- item
		}
	}
	return(trial)
}

bid_phase <- function(benefits, prices) {
	bidders <- unique(benefits$bidder)
	bid_list <- list()
	nbids <- 0
	for(current_bidder in bidders) {
		bidder_benefits <- subset(benefits, benefits$bidder == current_bidder)

		values <- merge(bidder_benefits, prices, by='item')
		values$value <- values$benefit - values$price
		values <- values[order(values$value, decreasing=TRUE), ]

		if(nrow(values) < 1)
			next

		max1_value <- values[1, 'value']
		if(is.na(max1_value))
			next
		max_item <- values[1, 'item']

		if(nrow(values) < 2) {
			max2_value <- 0.0
		} else {
			max2_value <- values[2, 'value']
			if(is.na(max2_value))
				max2_value <- 0.0
		}
		nbids <- nbids + 1
		bid_list[[nbids]] <- data.frame(bidder=current_bidder, item=max_item,
			bid = max1_value - max2_value + 1.0, stringsAsFactors=FALSE)
	}
	if(nbids > 0) {
		bids <- do.call('rbind', bid_list)
	} else {
		bids <- data.frame(bidder=character(0), item=character(0),
			bid=numeric(0), stringsAsFactors=FALSE)
	}
	return(bids)
}

assignment_phase <- function(bids, prices, assignments) {
	items <- unique(bids$item)
	for(current_item in items) {
		item_bids <- subset(bids, !is.na(bids$bid) & bids$item == current_item)

		if(nrow(item_bids) < 1)
			next

		item_bids <- item_bids[order(item_bids$bid, decreasing=TRUE), ]
		max_bid <- item_bids[1, 'bid']
		max_bidder <- item_bids[1, 'bidder']

		prices$price <- ifelse(prices$item == current_item,
			prices$price + max_bid, prices$price)
		assignments$assigned <- ifelse(assignments$item == current_item &
			assignments$bidder == max_bidder, TRUE, assignments$assigned)
		assignments$assigned <- ifelse(assignments$item == current_item &
			assignments$bidder != max_bidder, FALSE, assignments$assigned)
	}
	round_results <-list()
	round_results[['prices']] <- prices
	round_results[['assignments']] <- assignments
	return(round_results)
}

unmatched <- function(assignments) {
	items <- unique(assignments$item)
	for(current_item in items) {
		matches <- subset(assignments, assignments$item == current_item)
		if(!any(matches$assigned)) {
			return(TRUE)
		}
	}
	return(FALSE)
}

auction <- function(benefits) {
	prices <- data.frame(item=unique(benefits$item), price=0, 
	    stringsAsFactors=FALSE)
	assignments <- data.frame(bidder=benefits$bidder, item=benefits$item,
		assigned=FALSE, stringsAsFactors=FALSE)
	while(unmatched(assignments)) {
		bids <- bid_phase(benefits, prices)
		new_info <- assignment_phase(bids, prices, assignments)
		prices <- new_info$prices
		assignments <- new_info$assignments
	}
	return(assignments)
}
