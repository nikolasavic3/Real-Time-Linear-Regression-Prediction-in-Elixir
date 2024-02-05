defmodule BinanceLinearRegresion do
  def predict_price(amount, frame) do
    file = "BTCUSDT-data/#{frame}.csv"
    data = BinanceData.get_data_from_csv(file)
    time = get_time(amount)

    t =
      Integer.floor_div(time, 1000)
      |> DateTime.from_unix()

    tensor_y =
      Nx.tensor(list_element_numbers_to_tensors(Explorer.Series.to_list(data["close"])))

    tensor_x =
      Nx.tensor(list_element_numbers_to_tensors(Explorer.Series.to_list(data["close_time"])))

    model = Scholar.Linear.LinearRegression.fit(tensor_x, tensor_y)
    current_m = BinanceData.get_last_recent_kline_for_BTC()
    [data] = Map.get(current_m, :data)
    IO.inspect(data)
    price = Map.get(data, :close)

    prediction = Scholar.Linear.LinearRegression.predict(model, Nx.tensor(time))
    IO.puts("predicting for #{frame}:")
    loss = test(tensor_x, tensor_y)
    {[a], _} = List.pop_at(Nx.to_list(prediction), 0)

    %{
      loss: Nx.to_number(loss),
      current_price: price,
      predicted_price: a,
      prediction_time: t,
      current_time: DateTime.utc_now()
    }
  end

  def predict_price_all_models(point_x) do
    prediction0 = predict_price(point_x, "1s")
    prediction1 = predict_price(point_x, "1m")
    prediction2 = predict_price(point_x, "1h")
    prediction3 = predict_price(point_x, "1d")
    %{"1s": prediction0, "1m": prediction1, "1h": prediction2, "1d": prediction3}
  end

  def test(tensor_x, tensor_y) do
    train_range = 0..399//1
    test_range = 400..-1//1
    train_x = tensor_x[train_range]
    train_y = tensor_y[train_range]
    test_x = tensor_x[test_range]
    test_y = tensor_y[test_range]
    model = Scholar.Linear.LinearRegression.fit(train_x, train_y)
    prediction_tensor_y = Scholar.Linear.LinearRegression.predict(model, Nx.tensor(test_x))
    l = loss(test_y, prediction_tensor_y)
    IO.puts("loss (mean squared error):")
    IO.inspect(l)
    l
  end

  def loss(actual_y, predicted_y) do
    loss_val = mean_squared_error(actual_y, predicted_y)
    loss_val
  end

  def mean_squared_error(actual_y, predicted_y) do
    actual_y
    |> Nx.subtract(predicted_y)
    |> Nx.pow(2)
    |> Nx.mean()
  end

  def get_time(amount) do
    {_, b_time} = Binance.Market.get_time()
    time = b_time + amount * 1000
    time
  end

  def get_time_from_frame(amount, frame) do
    {amount, _} =
      case frame do
        "1s" ->
          {amount * 1000, :second}

        "1m" ->
          {amount * 1000 * 60, :minute}

        "1h" ->
          {amount * 1000 * 60 * 60, :hour}

        "1d" ->
          {amount * 1000 * 60 * 60 * 24, :day}

        _ ->
          {amount * 1000, :second}
      end

    {_, b_time} = Binance.Market.get_time()
    time = b_time + amount
    time
  end

  defp list_element_numbers_to_tensors(list) do
    Enum.map(list, fn x -> [x] end)
  end
end
