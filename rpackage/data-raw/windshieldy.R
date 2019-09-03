windshieldy1 <- read.table("data-raw/windshieldy1.txt")$V1
windshieldy2 <- read.table("data-raw/windshieldy2.txt")$V1
usethis::use_data(windshieldy1, windshieldy2, overwrite = TRUE)
