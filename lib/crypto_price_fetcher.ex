defmodule CryptoPriceFetcher do
  require HTTPoison

  def fetch_btc_price() do
    url = "https://api.coincap.io/v2/assets/bitcoin"

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_price(body)

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp parse_price(body) do
    with {:ok, data} <- Jason.decode(body),
         %{"data" => %{"priceUsd" => price_usd}, "timestamp" => timestamp} <- data do
      # current_time_utc = DateTime.utc_now()

      # local_time = DateTime.shift_zone(current_time_utc, "Europe/Paris", Tzdata.TimeZoneDatabase)
      {:ok, price_usd, timestamp}
    else
      error -> {:error, error}
    end
  end

  def update_price() do
    with {:ok, current_price, time} <- CryptoPriceFetcher.fetch_btc_price() do
      IO.puts("ID")
      IO.inspect(self())
      current_price_float = String.to_float(current_price)
      {x, y} = get_tensors_from_csv()
      updated_tensor_x = concatenate_number_to_tensor(x, time)
      updated_tensor_y = concatenate_number_to_tensor(y, current_price_float)

      print_tensors(updated_tensor_x, updated_tensor_y)
      save_tensors_to_files(updated_tensor_x, updated_tensor_y, "all_data.csv")
      :timer.sleep(1000 * 20)
      update_price(updated_tensor_x, updated_tensor_y)
    else
      {:error, _} = error -> error
    end
  end

  def update_price(x_tensor, y_tensor) do
    with {:ok, current_price, time} <- CryptoPriceFetcher.fetch_btc_price() do
      current_price_float = String.to_float(current_price)
      updated_tensor_x = concatenate_number_to_tensor(x_tensor, time)
      updated_tensor_y = concatenate_number_to_tensor(y_tensor, current_price_float)
      print_tensors(updated_tensor_x, updated_tensor_y)
      save_tensors_to_files(updated_tensor_x, updated_tensor_y, "all_data.csv")
      :timer.sleep(1000 * 20)
      update_price(updated_tensor_x, updated_tensor_y)
    else
      {:error, _} = error -> error
    end
  end

  def print_tensors(tensor_x, tensor_y) do
    IO.puts("tensor x:")
    IO.inspect(tensor_x)
    IO.puts("tensor y:")
    IO.inspect(tensor_y)
  end

  defp concatenate_number_to_tensor(tensor, number) do
    updated_tensor = Nx.concatenate([tensor, Nx.tensor([[number]])])
    updated_tensor
  end

  defp save_tensors_to_files(tensor_x, tensor_y, file) do
    b = Explorer.Series.from_tensor(tensor_y)
    a = Explorer.Series.from_tensor(tensor_x)
    df = Explorer.DataFrame.new(%{time: a, price: b})
    Explorer.DataFrame.to_csv(df, file)
  end

  def get_tensors_from_csv() do
    df_all = Explorer.DataFrame.from_csv!("all_data.csv")
    map = Explorer.DataFrame.to_series(df_all)
    old_x_vals = Explorer.Series.to_list(map["time"])
    old_y_vals = Explorer.Series.to_list(map["price"])
    IO.puts("old")
    IO.inspect(old_x_vals)
    old_tensors_x = list_to_tensors(old_x_vals)
    IO.puts("new")
    IO.inspect(old_tensors_x)
    old_tensors_y = list_to_tensors(old_y_vals)
    tensor_x = Nx.tensor(old_tensors_x)
    IO.puts("tensor")
    IO.inspect(tensor_x)
    tensor_y = Nx.tensor(old_tensors_y)
    {tensor_x, tensor_y}
  end

  defp list_to_tensors(list) do
    Enum.map(list, fn x -> [x] end)
  end
end
