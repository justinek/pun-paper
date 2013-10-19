d.c <- read.csv("../results_long.csv")

## split half analysis
n.samples = 1000
splitHalfCors = c()

for(i in 1:n.samples) {
  selected<-sample(nrow(d.c),nrow(d.c) / 2) 
  d.c.sample1 <- d.c[selected,] 
  d.c.sample2 <- d.c[-selected,]
  
  d.c.sample1.means <- aggregate(data=d.c.sample1, zscored ~ homophoneID, FUN = mean)
  d.c.sample2.means <- aggregate(data=d.c.sample2, zscored ~ homophoneID, FUN = mean)
  cor = cor(d.c.sample1.means$zscored, d.c.sample2.means$zscored)
  splitHalfCors <- c(splitHalfCors, cor)
}

mean(splitHalfCors)

d.c.splithalf <- data.frame(sample1 = d.c.sample1.means$zscored, 
                            sample2=d.c.sample2.means$zscored)

ggplot(data=d.c.splithalf, aes(x=sample1, y=sample2)) +
  geom_point() +
  theme_bw()

# get mean confusability ratings for all items/subjects
d.c.means <- summarySE(data=d.c, measurevar="zscored", groupvars="homophoneID")
ggplot(d.c.means, aes(x=homophoneID, y=zscored)) +
  geom_bar(color="black", fill="#FF9999",stat="identity") +
  geom_errorbar(aes(ymin=zscored-se, ymax=zscored+se), width=0.2) +
  theme_bw()

d.c.means.agg <- aggregate(data=d.c, zscored ~ homophoneID, FUN=mean)
write.csv(d.c.means.agg, "../../../Materials/confusability_ratings.csv")

# read in funniness ratings for near homophpone puns
f.n.ratings <- read.csv("../../../Materials/sentences_orig_withRatings.csv")
f.n.ratings.puns <- subset(f.n.ratings, sentenceType == "pun")
f.n.ratings.puns$confusability <- d.c.means$zscored
with(f.n.ratings.puns, cor.test(confusability, rating))
