#!/usr/bin/Rscript

match_make_trial <- function(control_ids=1:3, treatment_ids=c('a', 'b', 'c'),
	weights=runif(length(control_ids) * length(treatment_ids))) {
	cid_col <- integer()
	tid_col <- character()
	for(tid in treatment_ids) {
		for(cid in control_ids) {
			cid_col <- c(cid_col, cid)
			tid_col <- c(tid_col, tid)
		}
	}
	return(data.frame(control_id=cid_col, treatment_id=tid_col, weight=weights))
}

# function: mymatch_bid
# description: a bidding step of the maximum matching algorithm mymatch
# input: a dataframe with columns control_id, treatment_id, weight
# control_id and treatment_id should be integers while weights can be any
# numeric with some NA entries; these should be the treatments not yet
# assigned controls
# output: a dataframe with columns control_id, treatment_id, bid
# control_id and treatment_id should be integers while bid can be any
# numeric or NA
match_bid <- function(weights) {
	treatments <- unique(weights$treatment_id)
	bids <- data.frame(control_id=weights$control_id,
		treatment_id=weights$treatment_id, bid=NA)
	for(treat in treatments) {
		controls <- subset(weights, weights$treatment_id == treat)
		if(nrow(controls) < 1)
			next
		controls <- controls[order(controls$weight, decreasing=TRUE), ]

		max1 <- controls[1, 'weight']
		if(is.na(max1))
			next

		max_cid <- controls[1, 'control_id']
		max_tid <- controls[1, 'treatment_id']

		if(nrow(controls) < 2)
			max2 <- 0.0
		else {
			max2 <- controls[2, 'weight']
			if(is.na(max2))
				max2 <- 0.0
		}

		bids$bid <- ifelse(
			bids$control_id == max_cid & bids$treatment_id == max_tid,
			max1 - max2 + 1.0, bids$bid)
	}
	return(bids)
}

# function: mymatch_win
# description: a step of the maximum matching algorithm mymatch in which winning
# bidders are chosen after a bidding step
# input: weights, a dataframe with columns control_id, treatment_id, weight
# control_id and treatment_id should be integers while weights can be any
# bids, a dataframe with columns control_id, treatment_id, bid
# control_id and treatment_id should be integers while bid can be any
# numeric or NA
# output: a matching dataframe with columns control_id, treatment_id,
# weights holding weights updated with the bid increment
# matched where matched is a boolean TRUE or FALSE column
match_win <- function(weights, bids) {
	controls <- unique(bids$control_id)
	matches <- data.frame(control_id=bids$control_id,
		treatment_id=bids$treatment_id, weight=NA)
	for(cid in controls) {
		cid_bids <- subset(bids, bids$control_id == cid &
			!is.na(bids$bid))
		if(nrow(cid) < 1)
			next
		cid_bids <- cid_bids[order(cid_bids$bid, decreasing=TRUE), ]
		max_bid <- cid_bids[1, 'bid']
		if(is.na(max_bid))
			next
		max_tid <- cid_bids[1, 'treatment_id']


	}
}

# function: mymatch
# description: produces a maximum matching from a dataframe of edge weights
# until all treatments have been assigned a control, the function will
# alternate between calling mymatch_bid and mymatch_win
# input: a dataframe with columns control_id, treatment_id, weight
# control_id and treatment_id should be integers while weights can be any
# numeric with some NA entries
# output: a maximum matching dataframe with columns control_id, treatment_id,
# matched where matched is a boolean TRUE or FALSE column
match <- function(weights) {
}
