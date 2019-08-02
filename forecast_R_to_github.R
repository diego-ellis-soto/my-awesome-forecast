require(lubridate)
gflu = read.csv('http://www.google.org/flutrends/about/data/flu/us/data.txt',
                skip = 11) # skip the first 11 rows

y <- ts(gflu$Massachusetts)
arima_model <-   arima(y, order = c(3, 0, 1)) # number of lags that i need to look at. # Lag context
# Similar to state space models:
forecast = predict(arima_model, n.ahead = 10) # Make a new prediction for the model I made
# numbe rof steps ahead that i wanna forecast = 10

# Save the plot
jpeg('forecast_plot.jpg')
plot(y, type = 'l', ylab = 'Flu Index', lwd = 2, xlim = c(540, 640), ylim = c(0, 4000)) # plot original data
# Focus on end of time series and prediciton
lines(forecast$pred, col = 'dodgerblue2', lwd = 2)
dev.off()
# lets store the predicitons themselves
predictions = data.frame(time =  time(forecast$pred),
                         prediction = forecast$pred,
                         stde = forecast$se)
write.csv(predictions, file = 'predictions.csv', row.names = FALSE) 

# Download data, fit a model, make predictions, make a plot, save the data
# If i run this periodically i have allways most recen forecast.

# Build in schedulers: cron -> 
# Run the code every once in a while -> 
# crontab -e # Give me the cron table and let me edit it -e
# Run forecast every day at 2:26 am
# On the 26th minute of the second hour every day of every month and every day of the week then we tell it to run our file Rscript XXX.R
# 26 2 * * * Rscript /Users/diegoellis/Desktop/Iterative_forecast.R
# What is todays forecast
# if my computer is not on; it skips it.
# crontab -l # Show me my tasks in cron.
# In windows: Task Scheduler ->  Create basic task. -> 
# Phenocast -> using HPC and chron
# Downsides to cron: Sort of local -> shared server or own computer -> more dificult for larger collaborations OR event based trigers -> cant watch what is going on in the world -> As soon as new data is avialable it does not run; it runs on a schedule.

# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
# Continious integration:
# --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
# Software engineer safely modify code without breaking things -> Change code -> Run tests -> If it stil does what it should -> Update and change something
# Travic
# https://www.nature.com/articles/nbt.3780
# Travis + Containers -> Rerun all analyiss, produce new predictions and forecast and put them somewhere.
# This integrates directly into git and github. 

# Connect github account to continious integraiton serviece -> Use Travis 
# https://travis-ci.com -> Sign up with github
# Allow travis to put stuff back into our repository.
# Give it permision to do that -> Github account -> Settings -> Developer settings -> Personal access tokens -> Generate new token -> I call it continious analysis on travis -> I remember wha tit is for -> allow repo and click it -> Generate token -> Careful! Its a token thats essentially a password to my github account -> Copy the token -> Go back to travis -> My repo -> More options -> Settings ->  Environmental variables -> here we store an encripted version of my token -> Call it name github token -> go back to github repository -> create a new file called install.R this will go to a compeltely new computer -> Create a new file that travis will look at -> .travis.yml this is a special kind of file called yammel metadata language -> here is a pair of a thing and the value i want for it for communicating information -> tell it what computer language wer dealing with 
# language: r
# cache: packages
# install: # how do you set up the system before doing the key work
# - Rscript install.R # install the packages and then wer ready to go. 
# - script forecast.R # What the analysis is that we actually want to do
# We have our packages installed and run the script
# deploy:
# provider: pages # Where we wanna put things. Github pages
# Deploy these result, take the work we have done and put these results back soemwhere else in our case into our github repository, can be a webiste zB 
# skip_cleanup: true Dont delete everything 
# github_token: $GITHUB_TOKEN # remembers . $ = this is an environmental variable
# keep_history: true
# target_branch: master Where do we put the results that we got