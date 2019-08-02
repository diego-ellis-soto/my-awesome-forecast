gflu = read.csv("http://www.google.org/flutrends/about/data/flu/us/data.txt",skip=11)
y = ts(gflu$Massachusetts)
arima_model = arima(y, order = c(3, 0, 1))
forecast = predict(arima_model, n.ahead = 10)
print("forecasting...")
predictions = data.frame(time = time(forecast$pred), prediction = forecast$pred)
write.csv(predictions, "predictions.csv", row.names = FALSE)

jpeg("forecast_plot.jpg")
plot(y,type='l',ylab="Flu Index",lwd=2,xlim=c(540, 640),ylim=c(0, 4000))
lines(forecast$pred, col = 'blue', lwd=2)
dev.off()
# https://github.com/drgranger/auto-forecast-demo/blob/master/forecast.R
