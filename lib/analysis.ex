defmodule Analysis do
  def visualize_predictions(
        model,
        model_state,
        prices,
        window_size,
        target_window_size,
        batch_size
      ) do
    {_, predict_fn} = Axon.build(model)

    windows =
      prices
      |> Data.window(window_size, target_window_size)
      |> Data.batch(batch_size)
      |> Stream.map(&elem(&1, 0))

    predicted =
      Enum.flat_map(windows, fn window ->
        predict_fn.(model_state, window) |> Nx.to_flat_list()
      end)

    predicted
  end
end
