#Package installing
install.packages("worldfootballR")
install.packages("dplyr")

library(worldfootballR)
library(dplyr)

#Types of stats available:
  #standard
  #shooting
  #passing
  #passing_types
  #gca
  #defense
  #possession
  #playing_time
  #misc
  #keepers
  #keepers_adv
#Function that retrieves player stats for the 2022-2023 season in the 5 major Leagues (La Liga, Premier League, Serie A, Ligue 1 and Bundesliga)
big5_player_standard_stats <- fb_big5_advanced_season_stats(season_end_year= 2023, stat_type= "possession", team_or_player= "player")

retrieve_and_save_player_stats <- function() {
  # Define the available types of stats
  available_stats <- c("standard", "shooting", "passing", "passing_types", "gca", "defense", "possession",
                       "playing_time", "misc", "keepers", "keepers_adv")
  i=6
  # Iterate over each stat type
  for (stat_type in available_stats) {
    # Define the file name for the CSV file

    file_name <- paste0("datasets/", i,"_big5_player_", stat_type, "_stats.csv")
    
    # Retrieve player stats for the given stat_type and save as a CSV file
    player_stats <- fb_big5_advanced_season_stats(season_end_year = 2023, stat_type = stat_type, team_or_player = "player")
    write.csv(player_stats, file_name, row.names = FALSE)
    
    # Print a message confirming the file was saved
    cat("Player stats for", stat_type, "have been saved as", file_name, "\n")
    i=i+1
  }
}

# Call the function to retrieve and save player stats for all available types
retrieve_and_save_player_stats()
