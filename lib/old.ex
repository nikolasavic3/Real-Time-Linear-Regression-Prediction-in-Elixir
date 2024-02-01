# defmodule LinearRegression do

#   def prediction(x, y) do
#     model = Scholar.Linear.LinearRegression.fit(x, y)
#     IO.inspect(model)

#     IO.puts("x:")
#     IO.inspect(x)

#     IO.puts("y:")
#     IO.inspect(y)

#     x_string =
#       IO.gets(
#         "what is the x value, that you want to get the prediction the y value: (write exit to stop program): "
#       )

#     x_trimed = String.trim(x_string, "\n")

#     x_real = String.to_integer(x_trimed)

#     case Integer.parse(x_string) do
#       {number, _} ->
#         prediction = Scholar.Linear.LinearRegression.predict(model, x_real)
#         IO.puts("The prediction for x=#{x_real} > ")
#         IO.inspect(prediction)

#       :error ->
#         IO.puts("That is not valid input")
#         prediction(x, y)
#     end

#     x_next =
#       Nx.to_flat_list(x)
#       |> List.last()

#     next_x = x_next + 1

#     y_next =
#       IO.gets("Enter the next values for x=#{next_x} > ")
#       |> String.trim("\n")
#       |> String.to_integer()

#     x_values = Nx.concatenate([x, Nx.tensor([[next_x]])])
#     y_values = Nx.concatenate([y, Nx.tensor([[y_next]])])
#     prediction(x_values, y_values)
#   end
# end

# :timer.sleep(1000 * 20)
# case CryptoPriceFetcher.fetch_btc_price() do
#   {:ok, next_price, next_time_stamp} ->
#     IO.puts("new price: #{next_price}")
#     IO.puts("new time stamp: #{next_time_stamp}")
#     next_price_num = String.to_float(next_price)

#     updated_tensor_x =
#       Nx.concatenate([x_tensor, Nx.tensor([[next_time_stamp]], type: :f64)], axis: 1)

#     updated_tensor_y =
#       Nx.concatenate([y_tenosr, Nx.tensor([[next_price_num]], type: :f64)], axis: 1)

#     predict_next_price(updated_tensor_x, updated_tensor_y, next_time_stamp, next_price_num)

#   {:error, _} = error ->
#     error
# end

#   def predict() do
#     with {:ok, next_price, new_time} <- CryptoPriceFetcher.fetch_btc_price() do
#       price = String.to_float(next_price)
#       updated_x = Nx.tensor([[next_price]])
#       updated_y = Nx.tensor([[new_time]])

#       predict_next_price(updated_x, updated_y)
#     else
#       {:error, _} = erorr -> erorr
#     end
#   end

#   defp format_data(current_price) do
#     # Transform the current price to the format expected by your model
#     # Example: If your model expects a list of lists (even for a single value)
#     Nx.tensor([[current_price]])
#   end
# end
