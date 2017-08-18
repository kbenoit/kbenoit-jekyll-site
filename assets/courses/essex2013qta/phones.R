#####
##### Twitter data demonstration of sentiment using dictionaries
##### Ken Benoit
##### Quantitative Text Analysis 2F - Essex Summer School 2013
#####

# setwd("~/Dropbox/Classes/Essex QTA/Notes/Day 10 - Social Media/data")

# load the Android tweets
load(url("/assets/courses/essex2013qta/an.Rdata"))
# load the iPhone tweets
load(url("/assets/courses/essex2013qta/ip.Rdata"))

# create an identifier for the phone
phone <- c(rep("iPhone", nrow(ip.df)), rep("Android", nrow(an.df)))
# concatenate the two sets of tweets
df <- rbind(ip.df, an.df)
# represent phone as a factor
df$phone <- factor(phone)

# change some variable names
names(df)[1] <- "DOCUMENT"
names(df)[30] <- "USER"
# select only the rows with English tweets
df.small <- df[which(df$lang=="en"),]
# name the filename
df.small$FILENAME <- paste(df.small$phone, 1:nrow(df.small), sep="")
# select only a few variables
df.small <- df.small[,c("FILENAME", "DOCUMENT", "USER", "phone", "followers_count")]
# rename variable
names(df.small)[5] <- "followers"

# write the output to a comma-separated values file
write.csv(df.small, "twitter_phones.csv", row.names=FALSE)

