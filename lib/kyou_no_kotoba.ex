defmodule KyouNoKotoba do
  use Application

  def start(_type, _args) do
    IO.puts("Starting KyouNoKotoba")
    children = [ExampleConsumer]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
