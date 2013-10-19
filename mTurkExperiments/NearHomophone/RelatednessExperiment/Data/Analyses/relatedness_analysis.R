# reads in relatedness ratings in long form
r <- read.csv("../data_long.csv")

# computes mean and sd for each word pair
r.summary <- summarySE(r, measurevar="zscored", groupvars="pairID")

# reads in word pair information
pairs <- read.csv("../../../Materials/wordPairs.csv")
pairs$rating <- r.summary$zscored

# checks for weird effects of condition, etc
summary(lm(data=pairs, rating ~ condition))
  
# summarizes funniness rating for sentence type
pairs.summary <- summarySE(pairs, measurevar="rating", groupvars=c("sentenceType", "version"))

# plot
ggplot(pairs.summary, aes(x=sentenceType, y=rating, fill=version)) +
  geom_bar(color="black", stat="identity", position=position_dodge()) +
  geom_errorbar(position=position_dodge(0.9), aes(ymin=rating-ci, ymax=rating+ci),
                width=.2) +
                  theme_bw()