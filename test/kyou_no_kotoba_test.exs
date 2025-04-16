defmodule KyouNoKotobaTest do
  use ExUnit.Case
  doctest KyouNoKotoba

  test "test start" do
    KyouNoKotoba.start(3,3)
  end
end
