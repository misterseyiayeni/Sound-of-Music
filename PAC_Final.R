library(ranger)
library(caret)
library(magrittr)
library(dplyr)

songs_Treated <- read.csv("analysisData_Genre_Binned.csv", header = TRUE, stringsAsFactors = TRUE)
scoring_Data_Treated <- read.csv("scoringData_Genre_Binned.csv", header = TRUE, stringsAsFactors = TRUE)
songs <- read.csv('analysisData.csv', stringsAsFactors = TRUE)
scoringData = read.csv('scoringData.csv', stringsAsFactors = TRUE)
str(songs)

songs_Numeric <- songs_Treated %>%
  select(id, performer, rating, genre_standards, genre_pop, genre_country, genre_metal, genre_blues, genre_rap, genre_soul, genre_hiphop, genre_disco, genre_jazz, genre_reggae, genre_contemporary, genre_NA, genre_funk, genre_none, genre_rock, track_duration, danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo , time_signature)

scoring_Data_Numeric <- scoring_Data_Treated %>%
  select(id, performer, genre_standards, genre_pop, genre_country, genre_metal, genre_blues, genre_rap, genre_soul, genre_hiphop, genre_disco, genre_jazz, genre_reggae, genre_contemporary, genre_NA, genre_funk, genre_none, genre_rock, track_duration, danceability, energy, key, loudness, mode, speechiness, acousticness, instrumentalness, liveness, valence, tempo , time_signature)

hyperparam <- expand.grid(mtry = 4.8,
                          splitrule = c("variance"),
                          min.node.size = 1.5)


# Train and evaluate the model using 5-fold cross-validation

seed_songs <- set.seed(123)
cv_results <- caret::train(rating ~ performer + genre_standards + genre_pop + genre_country+ genre_blues + genre_rap + genre_soul + genre_hiphop + genre_disco + genre_contemporary + genre_funk + genre_none + genre_rock + track_duration + danceability + energy + key + loudness + mode + speechiness + acousticness + instrumentalness + liveness + valence + tempo + time_signature, 
                           data = songs_Numeric,
                           method = "ranger",
                           num.trees = 1500,
                           trControl = trainControl(method = "cv", number = 5, allowParallel = TRUE),
                           tuneGrid = hyperparam)

cv_results$bestTune
cv_results


# Fit and print the random forest model
songs_model_rand_for_v2_iter <- ranger(rating ~ performer + genre_standards + genre_pop + genre_country + genre_metal + genre_blues + genre_rap + genre_soul + genre_hiphop + genre_disco + genre_jazz + genre_reggae + genre_contemporary + genre_NA + genre_funk + genre_none + genre_rock + track_duration + danceability + energy + key + loudness + mode + speechiness + acousticness + instrumentalness + liveness + valence + tempo + time_signature,
                                       data = songs_Numeric,
                                       num.trees = 1500,
                                       mtry = cv_results$bestTune$mtry,
                                       min.node.size = cv_results$bestTune$min.node.size,
                                       splitrule = cv_results$bestTune$splitrule)
songs_model_rand_for_v2_iter


# Predict with the model

pred_rand_for_v2 <- predict(songs_model_rand_for_v2_iter, scoring_Data_Numeric, num.trees = 1500)$predictions


# Write the results to file

submissionFile_rand_for_v2 = data.frame(id = scoring_Data_Numeric$id, rating = pred_rand_for_v2)
write.csv(submissionFile_rand_for_v2, '50th_submission_saa2250.csv', row.names = F)

nrow(submissionFile_rand_for_v2)