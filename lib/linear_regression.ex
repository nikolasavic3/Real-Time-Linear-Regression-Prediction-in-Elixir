defmodule LinearRegression do
  require Scholar.Linear.LinearRegression

  @spec predict_next_price() :: {:error, any()}
  def predict_next_price() do
    # with {:ok, current_price, time} <- CryptoPriceFetcher.fetch_btc_price() do
    #   current_price_float = String.to_float(current_price)
    {tensor_x, tensor_y} = get_tensors_from_csv("all_data.csv")
    # old_x_val_int = Enum.map(old_x_vals, &trunc/1) makes the vals round
    # old_y_val_int = Enum.map(old_y_vals, &trunc/1)
    # updated_tensor_x = Nx.concatenate([old_x, Nx.tensor([[time]])], axis: 1)
    # axis is 1 so i will add the comlumns together
    # updated_tensor_y = Nx.concatenate([old_y, Nx.tensor([[current_price_float]])], axis: 1)
    # predict_next_price(updated_tensor_x, updated_tensor_y, time, current_price_float)
    model = Scholar.Linear.LinearRegression.fit(tensor_x, tensor_y)
    CryptoPriceFetcher.print_tensors(tensor_x, tensor_y)
    x_prediction_value = get_x_for_prediction_or_stop(tensor_x, tensor_y)
    prediction = Scholar.Linear.LinearRegression.predict(model, Nx.tensor(x_prediction_value))
    IO.puts("The prediction for x=#{x_prediction_value} > #{inspect(prediction)}")
    IO.puts("The model looks like this:\n#{inspect(model)}")
    # else
    #   {:error, _} = error -> error
    # end
  end

  # def predict_next_price(x_tensor, y_tenosr, x_val, y_val) do
  #   # model = Scholar.Linear.LinearRegression.fit(x_tensor, y_tenosr)
  #   # x_prediction_value = get_x_for_prediction_or_stop(x_tensor, y_tenosr)
  #   # prediction = Scholar.Linear.LinearRegression.predict(model, x_prediction_value)
  #   # IO.puts("The prediction for x=#{x_val} > #{inspect(prediction)}")
  #   # IO.puts("The model looks like this:\n#{inspect(model)}")
  # end

  defp get_tensors_from_csv(csv) do
    df_all = Explorer.DataFrame.from_csv!(csv)
    map = Explorer.DataFrame.to_series(df_all)
    old_x_vals = Explorer.Series.to_list(map["time"])
    old_y_vals = Explorer.Series.to_list(map["price"])
    tensor_x = Nx.tensor([old_x_vals])
    tensor_y = Nx.tensor([old_y_vals])
    {tensor_x, tensor_y}
  end

  defp get_x_for_prediction_or_stop(x_tensor, y_tensor) do
    x_string =
      case IO.gets("for how many seconds you want to know the prediction for ? (stop) ") do
        {:error, reason} ->
          df = Explorer.DataFrame.new(%{time: Nx.to_list(x_tensor), price: Nx.to_list(y_tensor)})
          Explorer.DataFrame.to_csv(df, "all_data.csv")
          System.halt(0)
          IO.puts(reason)

        x_string ->
          case String.starts_with?(x_string, "stop") do
            true ->
              b = Explorer.Series.from_tensor(y_tensor)
              a = Explorer.Series.from_tensor(x_tensor)
              df = Explorer.DataFrame.new(%{time: a, price: b})

              Explorer.DataFrame.to_csv(df, "all_data.csv")

            false ->
              x_string
          end
      end

    x_trimed = String.trim(x_string, "\n")
    x_prediction_value = String.to_integer(x_trimed)

    with {:ok, _, time} <- CryptoPriceFetcher.fetch_btc_price() do
      t = time + x_prediction_value * 1000
      t
    else
      {:error, _} = error -> error
    end
  end
end
