#Package installing
install.packages("worldfootballR")
install.packages("dplyr")

library(worldfootballR)
library(dplyr)

# Load the CSV file
data <- read.csv("datasets/1_top_5_leagues_clubs_2223_season.csv", stringsAsFactors = FALSE)

# View the loaded data
head(data)

# Define the base URL
base_url <- "https://www.transfermarkt.com"

nc_p_urls <- tm_team_player_urls(team_url = "https://www.transfermarkt.com/bayern-munich/startseite/verein/27?saison_id=2022")
nc_bios <- tm_player_bio(player_urls = nc_p_urls)

# Create an empty list to store the club dataframes
club_bios_list <- list()

# Create a progress bar
pb <- txtProgressBar(min = 0, max = nrow(data), style = 3)

# Set the progress bar width (optional)
options("width" = 60)

# Iterate over each club
for (i in 1:nrow(data)) {
  club_url <- paste0(base_url, data$CLUB_HREF[i])  # Construct the club URL
  club_short_name <- data$CLUB[i]  # Get the club's short name
  
  # Retrieve the player URLs for the club
  club_players_url <- tm_team_player_urls(team_url = club_url)
  
  # Retrieve the player bios for the club
  club_bios <- tm_player_bio(player_urls = club_players_url)
  
  # Keep only the desired columns
  club_bios <- club_bios %>%
    select(all_of(c("player_name", "date_of_birth", "age", "height", "citizenship", "current_club", "joined",
                    "position", "foot", "player_agent", "outfitter",
                    "instagram", "max_player_valuation", "max_player_valuation_date",
                    "URL"))) %>%
    mutate(short_name = club_short_name)  # Add the "short_name" column
  
  # Append the club's bios dataframe to the list
  club_bios_list[[i]] <- club_bios
  
  # Update the progress bar
  setTxtProgressBar(pb, i)
}

# Combine all club bios dataframes into a single dataframe with an index column
combined_bios <- bind_rows(club_bios_list, .id = "Index") %>%
  mutate(Index = as.integer(Index) - 1) %>%
  setNames(toupper(names(.)))

# View the combined bios dataframe
glimpse(combined_bios)

# Save the combined_bios dataframe as a CSV file
write.csv(combined_bios, "datasets/4_players_complete_info_2223_season_v3.csv", row.names = FALSE)
