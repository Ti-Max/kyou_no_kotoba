defmodule KyouNoKotoba do
  require Logger
  use Application

  def start(_type, _args) do
    Logger.info("Starting KyouNoKotoba")
    {:ok, _pid} = Supervisor.start_link([DiscordConsumer], strategy: :one_for_one)
  end
end
