drowning <- read.table("data-raw/drowning.txt")
colnames(drowning) <- c("year", "drownings")
usethis::use_data(drowning, overwrite = TRUE)
