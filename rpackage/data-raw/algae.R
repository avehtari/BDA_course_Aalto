algae <- read.csv("data-raw/algae.txt", header = FALSE)$V1
usethis::use_data(algae, overwrite = TRUE)
