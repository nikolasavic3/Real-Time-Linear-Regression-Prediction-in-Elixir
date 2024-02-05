defmodule BinanceData do
  require Logger

  @headers [
    "close",
    "high",
    "ignore",
    "low",
    "open",
    "close_time",
    "number_of_trades",
    "open_time",
    "quote_asset_volume",
    "taker_buy_base_asset_volume",
    "taker_buy_quote_asset_volume",
    "volume"
  ]
  def get_recent_klines_for_coin(coin, frame) do
    {_, data} = Binance.Market.get_klines(coin, frame)
    data
  end

  def get_last_recent_kline_for_BTC() do
    {_, data} = Binance.Market.get_klines("BTCUSDT", "1s", limit: 1)
    %{data: data, time: Time.utc_now()}
  end

  def update_csv_all_loop(coin) do
    pid1 = Task.start(fn -> update_csv_loop(coin, "1s") end)
    pid2 = Task.async(fn -> update_csv_loop(coin, "1m") end)
    pid3 = Task.async(fn -> update_csv_loop(coin, "1h") end)
    pid4 = Task.async(fn -> update_csv_loop(coin, "1d") end)
    IO.puts("spawned: ")
    pidovi = [pid1, pid2, pid3, pid4]
    IO.inspect(pidovi)
  end

  def update_csv_loop(coin, frame) do
    save_klines_for_coin(coin, frame)
    time = frame_to_mili_seconds(frame)
    :timer.sleep(time)
    update_csv_loop(coin, frame)
  end

  def save_klines_for_coin(coin, frame) do
    klines = get_recent_klines_for_coin(coin, frame)
    folder = "#{coin}-data"
    file = "#{frame}.csv"
    save_klines_to_csv(klines, folder, file)
  end

  defp save_klines_to_csv(klines, folder, file) do
    File.mkdir_p(folder)
    file_path = "#{folder}/#{file}"
    {:ok, file} = File.open(file_path, [:write])
    :ok = IO.write(file, Enum.join(@headers, ",") <> "\n")

    Enum.each(klines, fn kline ->
      a = Map.values(Map.from_struct(kline))
      # IO.inspect(Map.from_struct(kline))

      Enum.each(a, fn b ->
        IO.write(file, b)
        IO.write(file, ",")
      end)

      IO.write(file, "\n")
    end)

    IO.puts("updated #{file_path}")

    File.close(file)
  rescue
    exception -> Logger.error("Failed to write to CSV: #{inspect(exception)}")
  end

  @spec get_data_from_csv(binary()) :: Explorer.DataFrame.t()
  def get_data_from_csv(file) do
    df_all = Explorer.DataFrame.from_csv!(file)
    df_all
  end

  def frame_to_mili_seconds(frame) do
    amount = String.to_integer(String.at(frame, 0))

    {time} =
      case String.at(frame, 1) do
        "s" ->
          {amount * 1000}

        "m" ->
          {amount * 1000 * 60}

        "h" ->
          {amount * 1000 * 60 * 60}

        "d" ->
          {amount * 1000 * 60 * 60 * 24}

        _ ->
          {amount * 1000}
      end

    time
  end
end
