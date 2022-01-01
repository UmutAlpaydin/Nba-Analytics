library(nbastatR)
library(readr)
library(tidyverse)
library(gt)

Sys.setenv("VROOM_CONNECTION_SIZE" = 131072 * 2)
#nba_players <- nba_players()

#teams_players_stats(seasons = 2022, types = c("player", "team"),
#                    modes = c("PerGame", "Totals", "Per100Possessions"),
#                    tables = c("general", "defense", "clutch", "hustle", "shots", "shot locations"))



data_2022 <- read.csv("https://raw.githubusercontent.com/UmutAlpaydin/Nba-Analytics/main/2022_team_ratings.csv")
data_2021 <- read.csv("https://raw.githubusercontent.com/UmutAlpaydin/Nba-Analytics/main/2021_team_ratings.csv")

my_data <- as_tibble(data_2021)
my_data_2022 <- as_tibble(data_2022)
my_data %>%
  rename(
    Age2021 = Age,
    Pace2021 = Pace
  )

names(my_data)[names(my_data) == "Age"] <- "Age2021"
names(my_data)[names(my_data) == "Pace"] <- "Pace2021"
names(my_data_2022)[names(my_data_2022) == "Age"] <- "Age2022"
names(my_data_2022)[names(my_data_2022) == "Pace"] <- "Pace2022"
my_data_2022

output_df <- data.frame(Team = my_data_2022$Team,
                        Age_2021 = my_data$Age2021,
                        Pace_2021 = my_data$Pace2021,
                        Age_2022 = my_data_2022$Age2022,
                      Pace_2022 = my_data_2022$Pace2022)

output_df$Pace_Diff <- ((my_data_2022$Pace2022 - my_data$Pace2021)/ my_data_2022$Pace2022)*100
output_df$Age_Diff <- ((my_data_2022$Age2022 - my_data$Age2021)/my_data$Age2021)*100

output_df$Age_Diff <- format(round(output_df$Age_Diff, 2), nsmall = 2)
output_df$Pace_Diff <- format(round(output_df$Pace_Diff, 2), nsmall = 2)

output_df$Age_Diff <- as.numeric(output_df$Age_Diff)
output_df$Pace_Diff <- as.numeric(output_df$Pace_Diff)


output_df %>%
  gt() %>%
  tab_header( 
    title = "Nba Teams Pace Difference!", # ...with this title
    subtitle = "2020-2021 & 2021-2022 Seasons") %>% 
  fmt_number(
    columns = c(Pace_Diff), # Second column: mean_len (numeric)
    decimals = 4 
  ) %>% 
  fmt_number(
    columns = c(Age_Diff), # Third column: dose (numeric)
    decimals = 4 
  ) %>%  
  data_color( # Update cell colors...
    columns = c(Pace_Diff), # ...for supp column!
    colors = scales::col_numeric( 
      palette = c(
        "#FF0000","#FFF200","#1E9600"), # Two factor levels, two colors
      domain = c(-8, 6)# Levels
    )
  ) %>% 
  data_color( # Update cell colors...
    columns = c(Age_Diff), # ...for dose column 
    colors = scales::col_numeric( # <- bc it's numeric
      palette = c(
        "#1E9600","#FFF200","#FF0000"), # A color scheme (gradient)
      domain = c(-9,11) # Column scale endpoints
    ))
  
output_df$Pace_Diff


