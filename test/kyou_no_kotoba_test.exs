defmodule KyouNoKotobaTest do
  use ExUnit.Case
  doctest KyouNoKotoba

  test "greets the world" do
    assert KyouNoKotoba.hello() == :world
  end
end
