defmodule Data do
  def window(inputs, window_size, target_window_size) do
    inputs
    |> Stream.chunk_every(window_size + target_window_size, 1, :discard)
    |> Stream.map(fn window ->
      features =
        window
        |> Enum.take(window_size)
        |> Nx.tensor()
        |> Nx.new_axis(1)

      targets =
        window
        |> Enum.drop(window_size)
        |> Nx.tensor()
        |> Nx.new_axis(1)

      {features, targets}
    end)
  end

  def batch(inputs, batch_size) do
    inputs
    |> Stream.chunk_every(batch_size)
    |> Stream.map(fn windows ->
      {features, targets} = Enum.unzip(windows)
      {Nx.stack(features), Nx.stack(targets)}
    end)
  end
end
