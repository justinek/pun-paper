# read files
funniness_identical <- read.csv("../ProcessedData/sentences_funninessRatings_identical.csv")
funniness_near <- read.csv("../ProcessedData/sentences_funninessRatings_near.csv")
measures_identical <- read.csv("../ModelOutputs/identical_trigram_13_0.csv")
measures_near <- read.csv("../ModelOutputs/near_trigram_13_0.csv")

# filter out depuns
data_identical <- subset(join(funniness_identical, measures_identical, 
                              by=c("sentenceType", "sentenceID")), sentenceType!="depunned")
data_near <- join(funniness_near, measures_near, by=c("sentenceType", "sentenceID"))

# filter out the alternative non-puns
data_m1_identical <- head(data_identical, 130)
data_m1_near <- head(data_near, 160)

data_m1 <- rbind(data_m1_identical, data_m1_near)
with(data_m1, cor.test(entropy, funniness))
with(data_m1, cor.test(m1KL, funniness))
summary(lm(data=data_m1, funniness~ entropy + m1KL))

# pun + nonpun
data = rbind(data_identical, data_near)
#data = data_identical

data$type <- ifelse(data$sentenceType=="pun" & data$punType=="identical", "identicalPun",
                    ifelse(data$sentenceType=="pun" & data$punType=="near", "nearPun",
                           ifelse(data$sentenceType=="nonpun" & data$punType=="identical", "identicalNonpun",
                                  "nearNonpun")))
data$type <- factor(data$type)

# derive secondary measures
data$sumKL <- data$m1KL + data$m2KL
data$minKL <- ifelse(data$m1KL < data$m2KL, data$m1KL, data$m2KL)
data$support_m1 <- data$sum_m1_ngram + data$sum_m1_relatedness
data$support_m2 <- data$sum_m2_ngram + data$sum_m2_relatedness
data$support_diff <- data$support_m1 - data$support_m2
data$ngram_ratio <- data$sum_m1_ngram - data$sum_m2_ngram
data$relatedness_ratio <- data$sum_m1_relatedness - data$sum_m2_relatedness
data$relatedness_abratio <- abs(data$sum_m1_relatedness - data$sum_m2_relatedness)

# correlations
with(data, cor.test(entropy, funniness))
with(data, cor.test(m1KL, funniness))
summary(lm(data=data, funniness ~ entropy + m1KL))
summary(lm(data=data, entropy ~ sentenceType))
summary(lm(data=data, m1KL ~ sentenceType))

#summary(lm(data=data, entropy ~ sentenceType))
#summary(lm(data=data, m1KL ~ sentenceType))
summary(lm(data=data, funniness ~ entropy))
summary(lm(data=data, funniness ~ m1KL))
summary(lm(data=data, funniness ~ sum_m2_ngram))
summary(lm(data=data, funniness ~ sum_m2_relatedness))
summary(lm(data=data, funniness ~ sum_m2_ngram + sum_m2_relatedness))
summary(lm(data=data, funniness ~ support_m1 + support_m2))
#summary(lm(data=data, funniness ~ m2KL))
#summary(lm(data=data, funniness ~ minKL))
#summary(lm(data=data, funniness ~ sumKL))
#summary(lm(data=data, funniness ~ entropy + minKL))
#summary(lm(data=data, funniness ~ ngram_ratio))
#summary(lm(data=data, funniness ~ relatedness_ratio))
#summary(lm(data=data, funniness ~ relatedness_abratio))
summary(lm(data=data, funniness ~ sum_m1_ngram + sum_m2_ngram + sum_m1_relatedness +
  sum_m2_relatedness))
summary(lm(data=data, funniness ~ abs(p_m1_given_w - p_m2_given_w)))
summary(lm(data=data, funniness ~ sum_m1_ngram + sum_m2_ngram + sum_m1_relatedness +
  sum_m2_relatedness + entropy + m1KL + m2KL))

# individaul measures scatterplot
ggplot(data, aes(x=support_diff, y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

ggplot(data, aes(x=m1KL, y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

ggplot(data, aes(x=sum_m2_relatedness, y=funniness, color=sentenceType)) +
  geom_point() +
  theme_bw()

# individual meausures bar plo
entropy.summary <- summarySE(data=data, measurevar="entropy", groupvars=c("sentenceType", "punType"))
ggplot(data=entropy.summary, aes(x=sentenceType, y=entropy, fill=punType)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=entropy-se, ymax=entropy+se),width=0.2, position=position_dodge(0.9)) +
  theme_bw()

m1KL.summary <- summarySE(data=data, measurevar="m1KL", groupvars=c("sentenceType", "punType"))
ggplot(data=m1KL.summary, aes(x=sentenceType, y=m1KL, fill=punType)) +
  geom_bar(stat="identity", color="black", position=position_dodge()) +
  geom_errorbar(aes(ymin=m1KL-se, ymax=m1KL+se),width=0.2, position=position_dodge(0.9)) +
  theme_bw()

entropy.summary <- summarySE(data=data, measurevar="entropy", groupvars=c("sentenceType"))
ggplot(data=entropy.summary, aes(x=sentenceType, y=entropy, fill=sentenceType)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=entropy-se, ymax=entropy+se),width=0.2) +
  theme_bw()

m1KL.summary <- summarySE(data=data, measurevar="m1KL", groupvars=c("sentenceType"))
ggplot(data=m1KL.summary, aes(x=sentenceType, y=m1KL, fill=sentenceType)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=m1KL-se, ymax=m1KL+se),width=0.2) +
  theme_bw()

funniness.summary <-summarySE(data=data, measurevar="funniness", groupvars=c("sentenceType"))
ggplot(data=funniness.summary, aes(x=sentenceType, y=funniness, fill=sentenceType)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=funniness-se, ymax=funniness+se),width=0.2) +
  theme_bw()

# measures + funniness scatter plot
ggplot(data=data, aes(x=entropy, y=m1KL, color=sentenceType)) +
  geom_point(size=3) +
  theme_bw()

### plot ellipses

require(proto)
StatEllipse <- proto(ggplot2:::Stat,
{
  required_aes <- c("x", "y")
  default_geom <- function(.) GeomPath
  objname <- "ellipse"
  
  calculate_groups <- function(., data, scales, ...){
    .super$calculate_groups(., data, scales,...)
  }
  calculate <- function(., data, scales, level = 0.75, segments = 51,...){
    dfn <- 2
    dfd <- length(data$x) - 1
    if (dfd < 3){
      ellipse <- rbind(c(NA,NA))  
    } else {
      require(MASS)
      v <- cov.trob(cbind(data$x, data$y))
      shape <- v$cov
      center <- v$center
      radius <- sqrt(dfn * qf(level, dfn, dfd))
      angles <- (0:segments) * 2 * pi/segments
      unit.circle <- cbind(cos(angles), sin(angles))
      ellipse <- t(center + radius * t(unit.circle %*% chol(shape)))
    }
    
    ellipse <- as.data.frame(ellipse)
    colnames(ellipse) <- c("x","y")
    return(ellipse)
  }
}
)

stat_ellipse <- function(mapping=NULL, data=NULL, geom="path", position="identity", ...) {
  StatEllipse$new(mapping=mapping, data=data, geom=geom, position=position, ...)
}
stderr <- function(x) sqrt(var(x)/length(x))

## four groups (identical pun, near pun, identical nonpun, etc)
df_ell <- data.frame() 
for(g in levels(data$type)){df_ell <- 
  rbind(df_ell, cbind(as.data.frame(with(data[data$type==g,], 
                                         ellipse(cor(entropy, m1KL),
                                                 scale=c(stderr(entropy),stderr(m1KL)),
                                                 centre=c(mean(entropy),mean(m1KL))))),group=g))}


## two groups (pun, nonpun, collapse near and identical)
# df_ell <- data.frame() 
# for(g in levels(data$sentenceType)){df_ell <- 
#   rbind(df_ell, cbind(as.data.frame(with(data[data$sentenceType==g,], 
#                                          ellipse(cor(entropy, m1KL),
#                                                  scale=c(stderr(entropy),stderr(m1KL)),
#                                                  centre=c(mean(entropy),mean(m1KL))))),group=g))}

df_ell <- subset(df_ell, group!="depunned")
df_ell$punType <- ifelse(df_ell$group=="identicalPun" | df_ell$group=="identicalNonpun",
                         "identical", "near")
df_ell$sentenceType <- ifelse(df_ell$group=="identicalPun" | df_ell$group=="nearPun",
                         "pun", "nonpun")
#df_ell$sentenceType <- format(df_ell$sentenceType, width=2)
#df_ell$punType <- format(df_ell$punType, width=2)

###########
# important!!!
###########

# ellipse plot
ggplot(data, aes(x=entropy,y=m1KL,colour=sentenceType)) + 
  geom_path(data=df_ell, aes(x=x, y=y,colour=sentenceType, linetype=punType)) +
  #geom_point(alpha=0.5) +
  theme_bw() +
  xlab("Ambiguity") +
  ylab("Distinctiveness") +
  scale_color_manual(name="Sentence Type", limits=c("pun", "nonpun"), 
                     labels=c("Pun", "Non-pun"),
                     values=c("#CC0033", "#33CCCC")) +
  scale_linetype_discrete(name="Homophone Type", 
                          limits=c("identical","near"), labels=c("Identical", "Near")) +
                         theme(axis.title.x=element_text(size=16), 
                               axis.title.y=element_text(size=16), 
                               legend.text=element_text(size=14), 
                               legend.title=element_text(size=14),
                               legend.position=c(0.15, 0.78))
#####
# contour plot + scatter plot
#####
# label points with the sentence

data$label <- ''
data[39,]$label <- 
"An electrician is a bright spark\nwho knows what's watt."
data[144,]$label <- "My desk lamp uses a\nsixty watt light bulb."

Ambiguity = data$entropy
Distinctiveness = data$m1KL
Funniness = data$funniness
#Ambiguity = data$support_m1
#Distinctiveness = data$support_m2
#Funniness = data$funniness
m <- loess(Funniness ~ Ambiguity*Distinctiveness)
grid <- expand.grid(Ambiguity=do.breaks(c(min(Ambiguity),max(Ambiguity)),100),
                    Distinctiveness=do.breaks(c(min(Distinctiveness),max(Distinctiveness)),100))
grid$Funniness <- as.vector(predict(m,newdata=grid))
p <- ggplot(data=grid,aes(x=Ambiguity,y=Distinctiveness, z=Funniness)) +
  stat_contour(aes(color=..level..)) +
  geom_point(data=data,aes(x=entropy, y=m1KL, shape=sentenceType, color=funniness), size=3) +
  #geom_point(data=data,aes(x=support_m1, y=support_m2, shape=sentenceType, color=funniness), size=3) +
  #geom_text(data=data, aes(label=label)) +
  scale_shape_manual(values=c(1,17)) +
  #geom_path(data=df_ell, aes(x=ambiguity, y=distinctiveness)) +
  scale_colour_gradient(high="#990033", low="#FFCCCC") +
  #scale_x_continuous(limits=c(-0.1, max(Ambiguity))) +
  theme_bw() + theme(panel.grid.minor=element_blank(), 
                     panel.grid.major=element_blank(), 
                     axis.title.x=element_text(size=16), 
                     axis.title.y=element_text(size=16))
library(directlabels)
direct.label(p)

#####
# Bar plots
#####
# combine ambiguity, distinctiveness, and funniness bar plots for pun and nonpuns in three panels
p.ambiguity <- ggplot(data=entropy.summary, aes(x=sentenceType, y=entropy)) +
  geom_bar(stat="identity", color="black", fill="gray") +
  geom_errorbar(aes(ymin=entropy-se, ymax=entropy+se),width=0.2) +
  theme_bw() +
  xlab("") +
  ylab("Ambiguity") +
  theme(panel.grid.minor=element_blank(), 
          panel.grid.major=element_blank(), 
          axis.text.x=element_text(size=16), 
          axis.title.y=element_text(size=16))

p.distinctiveness <- ggplot(data=m1KL.summary, aes(x=sentenceType, y=m1KL)) +
  geom_bar(stat="identity", color="black", fill="gray") +
  geom_errorbar(aes(ymin=m1KL-se, ymax=m1KL+se),width=0.2) +
  theme_bw() +
  xlab("") +
  ylab("Distinctiveness") +
  theme(panel.grid.minor=element_blank(), 
        panel.grid.major=element_blank(), 
        axis.text.x=element_text(size=16), 
        axis.title.y=element_text(size=16))

p.funniness <- ggplot(data=funniness.summary, aes(x=sentenceType, y=funniness)) +
  geom_bar(stat="identity", color="black", fill="gray") +
  geom_errorbar(aes(ymin=funniness-se, ymax=funniness+se),width=0.2) +
  theme_bw() +
  xlab("") +
  ylab("Funniness") +
  theme(panel.grid.minor=element_blank(), 
        panel.grid.major=element_blank(), 
        axis.text.x=element_text(size=16), 
        axis.title.y=element_text(size=16))

multiplot(p.ambiguity, p.distinctiveness, p.funniness, cols=3)


#############
# just puns
#############
data.pun <- subset(data, sentenceType=="pun")
with(data.pun, cor.test(entropy, funniness))
with(data.pun, cor.test(m1KL, funniness))
with(data.pun, cor.test(sum_m2_ngram, funniness))
with(data.pun, cor.test(minKL, funniness))
with(data.pun, cor.test(support_m2, funniness))
summary(lm(data=data.pun, funniness ~ support_m1 + support_m2))
summary(lm(data=data.pun, funniness ~ sum_m1_relatedness + sum_m2_relatedness))
summary(lm(data=data.pun, funniness ~ p_m2_given_w))
summary(lm(data=data.pun, funniness ~ entropy))
summary(lm(data=data.pun, funniness ~ m1KL))
summary(lm(data=data.pun, funniness ~ m2KL))
summary(lm(data=data.pun, funniness ~ minKL))
summary(lm(data=data.pun, funniness ~ sumKL))
summary(lm(data=data.pun, funniness ~ entropy + m1KL))
summary(lm(data=data.pun, funniness ~ entropy + minKL))
summary(lm(data=data.pun, funniness ~ ngram_ratio))
summary(lm(data=data.pun, funniness ~ support_m1))
summary(lm(data=data.pun, funniness ~ relatedness_ratio))
summary(lm(data=data.pun, funniness ~ relatedness_abratio))
summary(lm(data=data.pun, funniness ~ sum_m2_ngram +
  sum_m2_relatedness))

data.pun.identical <- subset(data.pun, punType=="identical")
data.pun.near <- subset(data.pun, punType=="near")
with(data.pun.identical, cor.test(funniness, m1KL))
with(data.pun.near, cor.test(funniness, m1KL))

ggplot(data.pun, aes(x=m1KL, y=funniness)) +
  geom_point(color="#CC0033", aes(shape=punType)) +
  geom_smooth(method=lm, color="black", linetype=2, alpha=0.2)+
  theme_bw() +
  xlab("Distinctiveness") +
  ylab("Funniness") +
  scale_shape_manual(name="Pun Type", limits=c("identical", "near"), 
                       labels=c("Identical", "Near"),
                       values=c(19,1)) +
                            theme(axis.title.x=element_text(size=16), 
                                  axis.title.y=element_text(size=16), 
                                  legend.text=element_text(size=14), 
                                  legend.title=element_text(size=14),
                                  legend.position=c(0.15, 0.78))
  
meanFunniness <- mean(data.pun$funniness)
sdFunniness <- sd(data.pun$funniness)
veryFunnyCutoff <- meanFunniness
notVeryFunnyCutoff <- meanFunniness

data.pun$funniness_binned <- ifelse(data.pun$funniness < notVeryFunnyCutoff, "0", 
                                    ifelse(data.pun$funniness >= veryFunnyCutoff, "2", "1"))

pun.funniness.binned <- summarySE(data.pun, measurevar="funniness", groupvars=c("funniness_binned"))
pun.m1KL.binned <- summarySE(data.pun, measurevar="m1KL", groupvars=c("funniness_binned"))
pun.funniness.binned$m1KL_binned <- pun.m1KL.binned$m1KL
pun.funniness.binned$m1KL_se <- pun.m1KL.binned$se

###########
# important!!!
###########

ggplot(data.pun, aes(x=m1KL, y=funniness)) +
  geom_point(color="#CC0033", aes(shape=punType), alpha=1) +
  geom_smooth(method=lm, color="black", linetype=2, alpha=0.2)+
  #geom_text(aes(label=m1)) +
  #geom_point(data=pun.funniness.binned, aes(x=m1KL_binned,y=funniness), size=4, shape=23, fill="gray") +
  #geom_errorbar(aes(ymin=m1KL_binned-m1KL_se, ymax=m1KL_binned+m1KL_se), width=0.1) +
  theme_bw() +
  xlab("Distinctiveness") +
  ylab("Funniness") +
  scale_shape_manual(name="Pun Type", limits=c("identical", "near"), 
                     labels=c("Identical", "Near"),
                     values=c(19,1)) +
                       theme(axis.title.x=element_text(size=16), 
                             axis.title.y=element_text(size=16), 
                             legend.text=element_text(size=14), 
                             legend.title=element_text(size=14),
                             legend.position=c(0.8, 0.1),
                             panel.grid.minor.x=element_blank(),
                             panel.grid.major.x=element_blank(),
                             panel.grid.minor.y=element_blank())

# binned
ggplot(pun.funniness.binned, aes(x=m1KL_binned, y=funniness)) +
  geom_point(data=data.pun, color="#CC0033", aes(x=m1KL, y=funniness, shape=punType), alpha=1) +
  #geom_smooth(method=lm, color="black", linetype=2, alpha=0.2)+
  #geom_text(aes(label=m1)) +
  geom_point(size=4, shape=23, fill="gray") +
  #geom_errorbarh(aes(xmin=m1KL_binned-m1KL_se, xmax=m1KL_binned+m1KL_se), width=0.1) +
  theme_bw() +
  xlab("Distinctiveness") +
  ylab("Funniness") +
  scale_shape_manual(name="Pun Type", limits=c("identical", "near"), 
                     labels=c("Identical", "Near"),
                     values=c(19,1)) +
  theme(axis.title.x=element_text(size=16), 
        axis.title.y=element_text(size=16), 
        legend.text=element_text(size=14), 
        legend.title=element_text(size=14),
        legend.position=c(0.8, 0.1),
        panel.grid.minor.x=element_blank(),
        panel.grid.major.x=element_blank(),
        panel.grid.minor.y=element_blank())


ggplot(pun.funniness.binned, aes(x=funniness_binned, y=m1KL_binned, fill=funniness_binned)) +
  geom_bar(stat="identity", color="black") +
  geom_errorbar(aes(ymin=m1KL_binned-m1KL_se, ymax=m1KL_binned+m1KL_se), width=0.1) +
  theme_bw() +
  

cor.test(pun.funniness.binned$funniness, pun.m1KL.binned$m1KL)

######
# funniness ratings analysis
######
rawData_identical <- 
  subset(read.csv("../mTurkExperiments/IdenticalHomophone/FunninessExperiment/Data/ratings_long.csv"), uniqueID <= 235)
colnames(rawData_identical)[6] <- "sentenceID"
colnames(rawData_identical)[7] <- "rating"
rawData_identical <- join(rawData_identical, funniness_identical, by="sentenceID")
rawData_identical_clean <- data.frame(workerID=rawData_identical$workerID, 
                                      sentenceID=rawData_identical$sentenceID,
                                      rating=rawData_identical$rating,
                                      sentenceType=rawData_identical$sentenceType)
rawData_identical_clean$punType <- "identical"

rawData_near <- 
  subset(read.csv("../mTurkExperiments/NearHomophone/FunninessExperiment/Data/data_long.csv"))
colnames(rawData_near)[5] <- "sentenceID"
colnames(rawData_near)[8] <- "rating"
rawData_near <- join(rawData_near, funniness_near, by="sentenceID")
rawData_near_clean <- data.frame(workerID=rawData_near$workerID, 
                                      sentenceID=rawData_near$sentenceID,
                                      rating=rawData_near$rating,
                                      sentenceType=rawData_near$sentenceType)
rawData_near_clean$punType <- "near"

# randomly splits data
data_to_split <- subset(rbind(rawData_identical_clean, rawData_near_clean), sentenceType == "pun")
#data_to_split <- rbind(rawData_identical_clean, rawData_near_clean)
n <- nrow(data_to_split)
correlation = 0
i = 0
numIterations = 100
while (i < numIterations) {
  sample.1 <- sort(sample(1:n, n/2)) 
  sample.2 <- (1:n)[-sample.1]
  data.1 <- data_to_split[sample.1,]
  data.2 <- data_to_split[sample.2,]
  
  funniness_summary.1 = summarySE(data.1, measurevar="rating", groupvars = c("punType", "sentenceID"))
  funniness_summary.2 = summarySE(data.2, measurevar="rating", groupvars = c("punType", "sentenceID"))
  if (nrow(funniness_summary.1) == nrow(funniness_summary.2)) {
    correlation = correlation + cor(funniness_summary.1$rating, funniness_summary.2$rating)
    i = i + 1
  }
}
correlation = correlation/numIterations
splithalf <- data.frame(rating1=funniness_summary.1$rating, rating2=funniness_summary.2$rating,
                        punType=funniness_summary.1$punType, sentenceID=funniness_summary.1$sentenceID,
                        measure1=data.pun$m1KL,measure2=data.pun$sum_m2_relatedness)

ggplot(splithalf, aes(x=measure1, y=rating1)) +
  geom_point(shape=17, color="#990033") +
  #geom_point(shape=17, aes(color=punType)) +
  #geom_smooth(method=lm) +
  geom_smooth(data=splithalf, aes(x=measure1, y=rating1), method=lm, color="#990033") +
  #geom_point(data=splithalf, aes(x=rating1, y=rating2), shape=2, alpha=0.5) +
  #geom_smooth(data=splithalf, aes(x=rating1, y=rating2), method=lm, color="gray", alpha=0.2) +
  theme_bw()

