# Real-Time Linear Regression Cryptocurrencies Predictor in Elixir

A real-time linear regression model that predicts the price of the BTC USDT pair given the elapsed future time in seconds. Continuous and parallel update of CSV tables. Parallel model fitting, predicting using different time intervals for the model.

## Getting Started
These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Ubuntu
#### Prerequisites
Installing Elixir
```shell
wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb && sudo dpkg -i erlang-solutions_2.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install elixir
```
#### Installing
```shell
git clone https://github.com/nikolasavic3/Real-Time-Linear-Regression-Prediction-in-Elixir.git
cd real_time_linear_regression
mix deps.get
```
#### Usage
You can use one bash terminal to run program, but I recomend using two. Start the interactive elixir shell in each bash terminal (or just one) by running the following command:
```shell
iex -S mix
```
In the first terminal run the function that updates the csv files for the BTC-USDT pair:
```
BinanceData.update_csv_all_loop("BTCUSDT")
```
Use the second terminal to run the function that gives the price estimate for some time in seconds (in this case, we call the function to give the prediction of the price for 30 seconds in the future).
```
BinanceLinearRegresion.predict_price_all_models(30)
```
The function should return the predicted closing price, calculated using four different linear regression models, each trained on datasets with different time units: 1 day, 1 hour, 1 minute, and 1 second.

![image](https://github.com/nikolasavic3/Real-Time-Linear-Regression-Prediction-in-Elixir/assets/76233425/395d302e-ad00-4d81-977d-2ac6d6674ee6)
 

