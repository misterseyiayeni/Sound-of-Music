# PROJECT DESCRIPTION

This predictive analytics project involved the building of “a model using a dataset of popular songs to 
predict ratings based on auditory features of the songs included in scoringData.csv”. Scoring was based on Root Mean Squared Error (RMSE) which simply put is the extent to which the model’s predictions 
are wrong when compared with new data. Consequently, the lowest score wins the competition.

Note: Coding was done in R Studio with R version 4.2.2 on a PC with Windows 11 OS.

APPROACH
I split this project into the following stages:
1. Exploratory Data Analysis (EDA), which involved viewing the distribution of relevant variables in the dataset to 
discover variability, outliers, missing values, etc. This was done with a histogram.
2. Data pre-processing, which is the handling of missing values, lumping of categorical variables with high number 
of levels. This was done with an ifelse function.
3. Training of cleaned/tidy data while tuning the hyperparameters of the training function to derive optimized 
values. This was done with the train function.
4. Fitting a model with the data using optimized hyperparameters. Ranger model was used.
5. Predicting and uploading the results to Kaggle website to obtain an initial RMSE and ranking and after the 
competition closes, receive the final ranking.

ACTIONS TAKEN
After analysing the predictors, I discovered that genre column had NA values, empty categories and 2987 levels which 
was too much for the model. I then recategorized the genre column to create new features - prefixed with genre_ -
which I dummy-coded for processing by the model.
I then decided on the features to include in the model. The formula I used can be found below:
rating ~ performer + genre_standards + genre_pop + genre_country+ genre_blues + genre_rap + genre_soul + 
genre_hiphop + genre_disco + genre_contemporary + genre_funk + genre_none + genre_rock + track_duration + 
danceability + energy + key + loudness + mode + speechiness + acousticness + instrumentalness + liveness + valence + 
tempo + time_signature
The 5-fold cross-validation was done using the train function, supplying ranges of values to the model to identify the 
“sweet spot” of hyperparameter tuning. The best tune was then supplied to the ranger model.

OUTCOME
After performing a 5-fold cross validation, the training model returned the optimized hyperparameters mtry = 4.8, 
splitrule = c("variance"), min.node.size = 1.5 using num.trees = 1500 yielding an initial RMSE of 14.775.
After calling predict() using the tuned hyperparameters, I got and initial RMSE of 14.99678 which was finally increased to 
14.85831 after the other 50% of the data was used. I was finally ranked 34th out of 68 participants
