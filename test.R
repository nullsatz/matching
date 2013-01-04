source('match.R')

benefits <- trial_match()
prices <- data.frame(item=unique(benefits$item), price=0,
	stringsAsFactors=FALSE)

bidders <- unique(benefits$bidder)
bid_list <- list()
nbids <- 0

current_bidder <- bidders[1]
bidder_benefits <- subset(benefits, benefits$bidder == current_bidder)

values <- merge(bidder_benefits, prices, by='item')
values$value <- values$benefit - values$price
values <- values[order(values$value, decreasing=TRUE), ]

max1_value <- values[1, 'value']
max_item <- values[1, 'item']

max2_value <- values[2, 'value']

nbids <- nbids + 1
bid_list[[nbids]] <- data.frame(bidder=bidder, item=max_item,
	bid = max1_value - max2_value + 1.0, stringsAsFactors=FALSE)
