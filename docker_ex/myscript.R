library(tidystringdist)
df <- tidy_comb_all(iris, Species)
p <- tidy_stringdist(df)

write.csv(p, "p.csv")