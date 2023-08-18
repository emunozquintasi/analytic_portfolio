#Package installing
install.packages("worldfootballR")
install.packages("dplyr")

library(worldfootballR)
library(dplyr)

mapped_players <- player_dictionary_mapping()
dplyr::glimpse(mapped_players)

# Save the mapped_players dataframe as a CSV file
write.csv(mapped_players, "FBref_Transfermarkt_mapping.csv", row.names = FALSE)
