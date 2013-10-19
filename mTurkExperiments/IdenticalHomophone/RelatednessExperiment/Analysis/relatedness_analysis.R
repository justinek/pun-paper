d.r = read.csv("../Data/ratings_long.csv")

# check if there is an effect of condition, order, or word order
summary(lm(data=d.r, relatedness ~ condition))
summary(lm(data=d.r, relatedness ~ wordOrder))
summary(lm(data=d.r, relatedness ~ order)) # there is an order effect

# randomly splits data in half
n <- nrow(d.r)
sample.1 <- sort(sample(1:n, n/2)) 
sample.2 <- (1:n)[-sample.1]
d.r.1 <- d.r[sample.1,]
d.r.2 <- d.r[sample.2,]

# summarizes ratings for two halves
relatedness_summary.1 = summarySE(d.r.1, measurevar="relatedness", groupvars = c("uniquePairID"))
relatedness_summary.2 = summarySE(d.r.2, measurevar="relatedness", groupvars = c("uniquePairID"))

# combines unique word pair data with summary
uniquePairs <- read.csv("../../wordPairs_unique.csv")
# creates data frame that puts in the two 
splithalf <- uniquePairs
splithalf$relatedness1 = relatedness_summary.1$relatedness
splithalf$relatedness2 = relatedness_summary.2$relatedness

cor.test(splithalf$relatedness1, splithalf$relatedness2)

ggplot(splithalf, aes(x=relatedness1, y=relatedness2)) +
  geom_point() +
  theme_bw() +
  opts(title="Split half correlation of standardized relatedness ratings")

## now that we're convinced the relatedness ratings are sane,
# summarize and print it out to map onto word pairs by sentence data
# recorded in wordpairs_full
relatedness_summary = summarySE(d.r, measurevar="relatedness", groupvars=c("uniquePairID"))
write.csv(relatedness_summary, "../Data/relatedness_summary.csv")

# did the matching of word pairs with relatedness ratings in python. 
# full data now stored in ../../wordPairs_full_withRatings.csv
# read in that data
pairs_relatedness <- read.csv("../../wordPairs_full_withRatings.csv")
pairs_relatedness$isOrig = factor(pairs_relatedness$isOrig)
pairs_relatedness$observed = factor(pairs_relatedness$observed)


# summarize relatedness by sentence type
sentenceType_relatedness_summary <- summarySE(pairs_relatedness, measurevar="relatedness", groupvars=c("sentenceType", "isOrig"))
rplot <- ggplot(sentenceType_relatedness_summary, aes(x=sentenceType, y=relatedness, fill=isOrig)) +
  geom_bar(position=position_dodge(), color="black", stat="identity") +
  geom_errorbar(aes(ymin=relatedness-ci, ymax=relatedness+ci),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9)) +
                  theme_bw() +
                  xlab("") +
                  ylab("Relatedness (z-scored)") +
                  scale_fill_discrete(name="Homophone type",
                                      breaks=c("0", "1"),
                                      labels=c("Observed", "Alternative")) +
                                        scale_x_discrete(limits=c("pun","depunned","nonpun"), labels=c("Pun", "De-punned", "Non-pun")) +
                                        theme(axis.title.y = element_text(size=16),
                                              axis.text.x  = element_text(size=16), 
                                              legend.text = element_text(size=12),
                                              legend.title = element_text(size=12),
                                              legend.position=c(0.25,0.85)) +
                                                coord_equal(1.15/0.3)





