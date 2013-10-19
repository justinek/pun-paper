# reads in data containing the long form of ratings for each sentence
data = read.csv("../Data/ratings_long.csv")


## Summarizes data.
## Gives count, mean, standard deviation, standard error of the mean, and confidence interval (default 95%).
##   data: a data frame.
##   measurevar: the name of a column that contains the variable to be summariezed
##   groupvars: a vector containing names of columns that contain grouping variables
##   na.rm: a boolean that indicates whether to ignore NA's
##   conf.interval: the percent range of the confidence interval (default is 95%)
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  require(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This is does the summary; it's not easy to understand...
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun= function(xx, col, na.rm) {
                   c( N    = length2(xx[,col], na.rm=na.rm),
                      mean = mean   (xx[,col], na.rm=na.rm),
                      sd   = sd     (xx[,col], na.rm=na.rm)
                   )
                 },
                 measurevar,
                 na.rm
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean"=measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}
## Norms the data within specified groups in a data frame; it normalizes each
## subject (identified by idvar) so that they have the same mean, within each group
## specified by betweenvars.
##   data: a data frame.
##   idvar: the name of a column that identifies each subject (or matched subjects)
##   measurevar: the name of a column that contains the variable to be summariezed
##   betweenvars: a vector containing names of columns that are between-subjects variables
##   na.rm: a boolean that indicates whether to ignore NA's
normDataWithin <- function(data=NULL, idvar, measurevar, betweenvars=NULL,
                           na.rm=FALSE, .drop=TRUE) {
  require(plyr)
  
  # Measure var on left, idvar + between vars on right of formula.
  data.subjMean <- ddply(data, c(idvar, betweenvars), .drop=.drop,
                         .fun = function(xx, col, na.rm) {
                           c(subjMean = mean(xx[,col], na.rm=na.rm))
                         },
                         measurevar,
                         na.rm
  )
  
  # Put the subject means with original data
  data <- merge(data, data.subjMean)
  
  # Get the normalized data in a new column
  measureNormedVar <- paste(measurevar, "Normed", sep="")
  data[,measureNormedVar] <- data[,measurevar] - data[,"subjMean"] +
    mean(data[,measurevar], na.rm=na.rm)
  
  # Remove this subject mean column
  data$subjMean <- NULL
  
  return(data)
}

# summarizes all the ratings
funniness_summary = summarySE(data, measurevar="funniness", groupvars = c("uniqueID"))
correctness_summary = summarySE(data, measurevar="correctness", groupvars = c("uniqueID"))

# reads in data containing all the information for each sentence, including ID, homophone, is pun, etc
sentences = read.csv("../../sentences.csv")

# combines info from sentence data frame with the ratings
sentences.rating <- sentences
sentences.rating$funniness = funniness_summary$funniness
sentences.rating$correctness = correctness_summary$correctness


# randomly splits data in half

n <- nrow(data)
sample.1 <- sort(sample(1:n, n/2)) 
sample.2 <- (1:n)[-sample.1]
data.1 <- data[sample.1,]
data.2 <- data[sample.2,]

# summarizes ratings for two halves
funniness_summary.1 = summarySE(data.1, measurevar="funniness", groupvars = c("uniqueID"))
funniness_summary.2 = summarySE(data.2, measurevar="funniness", groupvars = c("uniqueID"))
correctness_summary.1 = summarySE(data.1, measurevar="correctness", groupvars = c("uniqueID"))
correctness_summary.2 = summarySE(data.2, measurevar="correctness", groupvars = c("uniqueID"))

# combines sentences data with the ratings from the split halves
sentences.rating.1 <- sentences
sentences.rating.1$funniness = funniness_summary.1$funniness
sentences.rating.1$correctness = correctness_summary.1$correctness

sentences.rating.2 <- sentences
sentences.rating.2$funniness = funniness_summary.2$funniness
sentences.rating.2$correctness = correctness_summary.2$correctness

# creates dataframe containing sample 1 and sample 2
splithalf = sentences
splithalf$funniness1 = sentences.rating.1$funniness
splithalf$funniness2 = sentences.rating.2$funniness
splithalf$correctness1 = sentences.rating.1$correctness
splithalf$correctness2 = sentences.rating.2$correctness

# correlation between the full split samples
cor.test(splithalf$funniness1, splithalf$funniness2)
cor.test(splithalf$correctness1, splithalf$correctness2)

## plot and visualize the split half correlations for funniness for all sentences
ggplot(splithalf, aes(x=funniness1, y=funniness2, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  opts(title="Split half correlation of funniness for all sentences")

ggplot(splithalf, aes(x=correctness1, y=correctness2, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  opts(title="Split half correlation of correctness for all sentences")

# correlation between the split samples for original sentences only
splithalf.orig = splithalf[splithalf$isOrig == 0,]
splithalf.orig.puns = splithalf.orig[splithalf.orig$sentenceType == "pun",]
splithalf.orig.puns.depuns = splithalf.orig[splithalf.orig$sentenceType != "nonpun",]

cor.test(splithalf.orig$funniness1, splithalf.orig$funniness2)
cor.test(splithalf.orig$correctness1, splithalf.orig$correctness2)
cor.test(splithalf.orig.puns$funniness1, splithalf.orig.puns$funniness2)
cor.test(splithalf.orig.puns$correctness1, splithalf.orig.puns$correctness2)
cor.test(splithalf.orig.puns.depuns$funniness1, splithalf.orig.puns.depuns$funniness2)
cor.test(splithalf.orig.puns.depuns$correctness1, splithalf.orig.puns.depuns$correctness2)

## plot and visualize the split half correlations for funniness for ORIG sentences
ggplot(splithalf.orig, aes(x=funniness1, y=funniness2, color=sentenceType)) +
  geom_point() +
  theme_bw()

## plot and visualize the split half correlations for funniness for ORIG PUNS
ggplot(splithalf.orig.puns, aes(x=funniness1, y=funniness2)) +
  geom_point() +
  theme_bw() +
  opts(title="Split half correlation of funniiness for all original puns")

## plot and visualize the split half correlations for correctness for ORIG PUNS
ggplot(splithalf.orig.puns, aes(x=correctness1, y=correctness2)) +
  geom_point() +
  theme_bw() +
  opts(title="Split half correlation of correctness for all original puns")

## plot and visualize the split half correlations for correctness for ORIG sentences
ggplot(splithalf.orig, aes(x=funniness1, y=funniness2, color=sentenceType)) +
  geom_point() +
  theme_bw() +
  xlab("Funniness 1") +
  ylab("Funniness 2") +
  scale_color_discrete(name="Sentence Type") +
  theme(legend.title = element_text(size=16)) +
  theme(legend.text = element_text(size=16)) +
  theme(axis.title.x= element_text(size=16)) +
  theme(axis.title.y= element_text(size=16))

cor.test(splithalf.orig$funniness1, splithalf.orig$funniness2)

# correlation between the split samples for modified sentences only
splithalf.mod = splithalf[splithalf$isOrig == 1,]
cor.test(splithalf.mod$funniness1, splithalf.mod$funniness2)
cor.test(splithalf.mod$correctness1, splithalf.mod$correctness2)

## plot and visualize the split half correlations for funniness for MOD sentences
ggplot(splithalf.mod, aes(x=funniness1, y=funniness2, color=sentenceType)) +
  geom_point() +
  theme_bw()

ggplot(splithalf.mod, aes(x=correctness1, y=correctness2, color=sentenceType)) +
  geom_point() +
  theme_bw()

## summarize funniness for different types of sentences

sentences.rating$isOrig = factor(sentences.rating$isOrig)
funniness_type_summary = summarySE(sentences.rating, measurevar="funniness", groupvars=c("sentenceType", "isOrig"))

ggplot(funniness_type_summary, aes(x=sentenceType, y=funniness, fill=isOrig)) +
  geom_bar(position=position_dodge(), color="black", stat="identity") +
  geom_errorbar(aes(ymin=funniness-ci, ymax=funniness+ci),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9)) +
                  theme_bw() +
                  scale_fill_discrete(name="",
                                      breaks=c("0", "1"),
                                      labels=c("Original", "Modified")) +
  opts(title="Funniness across sentence types") +
  scale_x_discrete(limits=c("pun","depunned","nonpun")) +
  xlab("")
       


## summarize correctness for different types of sentences

correctness_type_summary = summarySE(sentences.rating, measurevar="correctness", groupvars=c("sentenceType", "isOrig"))

ggplot(correctness_type_summary, aes(x=sentenceType, y=correctness, fill=isOrig)) +
  geom_bar(position=position_dodge(), color="black", stat="identity") +
  geom_errorbar(aes(ymin=correctness-ci, ymax=correctness+ci),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9)) +
                  theme_bw() +
                  scale_fill_discrete(name="",
                                      breaks=c("0", "1"),
                                      labels=c("Original", "Modified")) +
                                        opts(title="Correctness across sentence types")

## visualizes relationship between correctness and funniness for ALL sentences
ggplot(sentences.rating, aes(x=correctness, y=funniness, color=sentenceType, shape=isOrig)) +
  geom_point() +
  scale_shape_manual(values=c(16,4)) +
  theme_bw() +
  opts(title="Correlation between funniness and correctness for all sentences")
  
cor.test(sentences.rating$correctness, sentences.rating$funniness)

## visualizes relationship between correctness and funniness for ORIG sentences
sentences.rating.orig = sentences.rating[sentences.rating$isOrig=="0",]

funniness_orig_summary = summarySE(sentences.rating.orig, measurevar="funniness", groupvars=c("sentenceType"))

fplot <- ggplot(funniness_orig_summary, aes(x=sentenceType, y=funniness, fill=sentenceType)) +
  geom_bar(position=position_dodge(width=0.5), color="black", stat="identity") +
  geom_errorbar(aes(ymin=funniness-ci, ymax=funniness+ci),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9)) +
                  theme_bw() +
                  scale_x_discrete(limits=c("pun","depunned","nonpun"), labels=c("Pun", "De-punned", "Non-pun")) +
                  xlab("")+ 
                  ylab("Funniness (z-scored)") +
                  scale_fill_manual(guide=FALSE, values=c("#66CC33", "#56B4E9", "#FF9999")) +
                                         theme(axis.title.y = element_text(size=16),
                                              axis.text.x  = element_text(size=16), 
                                              legend.text = element_text(size=14),
                                              legend.title = element_text(size=16)) + 
                                                coord_equal(1/0.45)


ggplot(sentences.rating.orig, aes(x=funniness, y=correctness, color=sentenceType)) +
  geom_point() +
  theme_bw()

## visualizes relationship between correctness and funniness for original puns
sentences.rating.orig.puns = sentences.rating.orig[sentences.rating.orig$sentenceType=="pun",]
ggplot(sentences.rating.orig.puns, aes(x=funniness, y=correctness)) +
  geom_point() +
  theme_bw() +
  opts(title="Correlation between funniness and correctness for original puns")

cor.test(sentences.rating.orig.puns$funniness, sentences.rating.orig.puns$correctness)

## filter out non-puns
sentences.rating.orig.puns.depunned <- 
  sentences.rating.orig[(sentences.rating.orig$sentenceType != "nonpun") & (sentences.rating.orig$phoneticID <= 40),]
puns.depunned.byItem.summary <- 
  summarySE(sentences.rating.orig.puns.depunned, measurevar="funniness", groupvars=c("phoneticID", "sentenceType"))

ggplot(puns.depunned.byItem.summary, aes(x=phoneticID, y=funniness, fill=sentenceType)) +
  geom_bar(position=position_dodge(0.9), color="black", stat="identity") +
  theme_bw()

puns.depunned.summary <- 
  summarySE(sentences.rating.orig.puns.depunned, measurevar="funniness", groupvars=c("sentenceType"))

ggplot(puns.depunned.summary, aes(x=sentenceType, y=funniness, fill=sentenceType)) +
  geom_bar(position=position_dodge(0.9), color="black", stat="identity") +
  geom_errorbar(aes(ymin=funniness-ci, ymax=funniness+ci),
                width=.2) +
  theme_bw()


## visualizes relationship between correctness and funniness for modified non-puns
sentences.rating.mod = sentences.rating[sentences.rating$isOrig=="1",]
sentences.rating.mod.nonpuns = sentences.rating.mod[sentences.rating.mod$sentenceType=="nonpun",]
ggplot(sentences.rating.mod.nonpuns, aes(x=funniness, y=correctness)) +
  geom_point() +
  theme_bw()

cor.test(sentences.rating.mod.nonpuns$funniness, sentences.rating.mod.nonpuns$correctness)

## visualizes relationship between correctness and funniness for modified puns
sentences.rating.mod.puns = sentences.rating.mod[sentences.rating.mod$sentenceType=="pun",]
ggplot(sentences.rating.mod.puns, aes(x=funniness, y=correctness)) +
  geom_point() +
  theme_bw()

cor.test(sentences.rating.mod.nonpuns$funniness, sentences.rating.mod.nonpuns$correctness)

## depunning analysis
sentences.rating.orig.puns.predepunned = sentences.rating.orig.puns[1:40,]
sentences.rating.orig.depunned = sentences.rating.orig[sentences.rating.orig$sentenceType=="depunned",]
sentences.rating.orig.depunned$row.names <- NULL

sentences.rating.orig.depunned.analysis = merge(sentences.rating.orig.puns.predepunned, sentences.rating.orig.depunned)

t.test(sentences.rating.orig.puns.predepunned$funniness,sentences.rating.orig.depunned$funniness, paired=T)

sentences.rating.mod.puns <-sentences.rating[sentences.rating$isOrig=="1" & sentences.rating$sentenceType=="pun",]
sentences.rating.mod.depunned <-sentences.rating[sentences.rating$isOrig=="1" & sentences.rating$sentenceType=="depunned",]
sentences.rating.orig.nonpun <- sentences.rating[sentences.rating$isOrig=="0" & sentences.rating$sentenceType=="nonpun",]

sentences.rating.naturalSentences <- rbind(sentences.rating.mod.puns, sentences.rating.mod.depunned, sentences.rating.orig.nonpun)

naturalSentences.funniness.summary <- summarySE(sentences.rating.naturalSentences, measurevar="funniness", groupvars=c("sentenceType"))

ggplot(naturalSentences.funniness.summary, aes(x=sentenceType, y=funniness, fill=sentenceType)) +
  geom_bar(color="black", stat="identity") +
  geom_errorbar(aes(ymin=funniness-ci, ymax=funniness+ci),
                width=.2) +
                  theme_bw() +
                  scale_x_discrete(limits=c("pun", "nonpun", "depunned")) +
                  scale_fill_discrete(guide=FALSE) +
                  xlab("") +
                  theme(axis.title.y = element_text(size=16),
                        axis.text.x  = element_text(size=16))