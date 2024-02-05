defmodule BinanceDTest do
  use ExUnit.Case
  doctest BinanceData

  test "frame_to_mili_seconds" do
    assert BinanceData.frame_to_mili_seconds("3s") == 3000
  end

  # test
end
