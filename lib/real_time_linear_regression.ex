defmodule RealTimeLinearRegression do
  require Scholar.Linear.LinearRegression

  def predict_next_price() do
    {tensor_x, tensor_y} = CryptoPriceFetcher.get_tensors_from_csv()
    model = Scholar.Linear.LinearRegression.fit(tensor_x, tensor_y)
    CryptoPriceFetcher.print_tensors(tensor_x, tensor_y)
    x_prediction_value = get_x_for_prediction_or_stop(tensor_x, tensor_y)
    prediction = Scholar.Linear.LinearRegression.predict(model, Nx.tensor(x_prediction_value))
    IO.puts("The prediction for x=#{x_prediction_value} > #{inspect(prediction)}")
    IO.puts("The model looks like this:\n#{inspect(model)}")
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
