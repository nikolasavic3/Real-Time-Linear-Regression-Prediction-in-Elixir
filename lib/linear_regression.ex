defmodule LinearRegression do
  def prediction(x, y) do
    model = Scholar.Linear.LinearRegression.fit(x, y)
    IO.inspect(model)

    IO.puts("x:")
    IO.inspect(x)

    IO.puts("y:")
    IO.inspect(y)

    x_string =
      IO.gets(
        "what is the x value, that you want to get the prediction the y value: (write exit to stop program): "
      )

    x_trimed = String.trim(x_string, "\n")

    x_real = String.to_integer(x_trimed)

    case Integer.parse(x_string) do
      {number, _} ->
        prediction = Scholar.Linear.LinearRegression.predict(model, x_real)
        IO.puts("The prediction for x=#{x_real} > ")
        IO.inspect(prediction)

      :error ->
        IO.puts("That is not valid input")
        prediction(x, y)
    end

    x_next =
      Nx.to_flat_list(x)
      |> List.last()

    next_x = x_next + 1

    y_next =
      IO.gets("Enter the next values for x=#{next_x} > ")
      |> String.trim("\n")
      |> String.to_integer()

    x_values = Nx.concatenate([x, Nx.tensor([[next_x]])])
    y_values = Nx.concatenate([y, Nx.tensor([[y_next]])])
    prediction(x_values, y_values)
  end
end
