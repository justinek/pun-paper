c <- read.delim("targetWordsRatings_subset1-roger.txt")

with(c, cor.test(roger_rating, noah_rating))
with(c, cor.test(phoneDist, roger_rating))
with(c, cor.test(phoneDist, funniness))
with(c, cor.test(roger_rating, funniness))
with(c, cor.test(noah_rating, phoneDist))