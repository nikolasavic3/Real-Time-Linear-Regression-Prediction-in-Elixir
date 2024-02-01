# defmodule RealTimeLinearRegression do
#   @moduledoc """
#   Documentation for `LinearR`.
#   """

#   @doc """
#   Hello world.

#   ## Examples

#       iex> LinearR.hello()
#       :world

#   """

#   # Nx.default_backend(EXLA.Backend)
#   # Nx.Defn.default_options(compiler: EXLA)

#   m = 1 * 10
#   b = 0 * 10

#   key = Nx.Random.key(42)
#   size = 4
#   # {x, new_key} = Nx.Random.uniform(key, 1, 0.1, shape: {size, 1})
#   x = Nx.iota({size, 1})

#   {noise_x, key} = Nx.Random.normal(key, 0.0, 0.1, shape: {size, 1})
#          y =
#     m
#     |> Nx.multiply(Nx.add(x, noise_x))
#     |> Nx.add(b)

#   # IO.puts("U IZRADI")

#   LinearRegression.prediction(x, y)

defmodule RealTimeLinearRegression do
  def run do
    case LinearRegression.predict_next_price() do
      {:ok, prediction} ->
        IO.puts("Predicted next price: #{prediction}")

      {:error, reason} ->
        IO.puts("Failed to predict the price: #{reason}")
    end
  end
end

# model = Scholar.Linear.LinearRegression.fit(x, y)
# IO.inspect(model)

# IO.puts("x:")
# IO.inspect(x)

# IO.puts("y:")
# IO.inspect(y)

# x_2 = 1
# IO.puts("x_2:")
# IO.inspect(x_2)

# IO.puts("prediction for x_2:")
# prediction = Scholar.Linear.LinearRegression.predict(model, x_2)
# IO.inspect(prediction)

# x2 = Nx.concatenate([x, Nx.tensor([[x_2]])])
# IO.puts("new tenosor x2:")
# IO.inspect(x2)

# y_2 = 10
# IO.puts("Real value y2 for x2:")
# IO.inspect(y_2)

# y2 = Nx.concatenate([y, Nx.tensor([[y_2]])])
# IO.puts("new tenosor y2:")
# IO.inspect(y2)

# # defp predict(x_1, y_1, x_2) do
# model2 = Scholar.Linear.LinearRegression.fit(x2, y2)
# IO.puts("updated preditction: ")
# IO.inspect(Scholar.Linear.LinearRegression.predict(model2, 1))
# end
# end
