import Config

config :nostrum, token: System.fetch_env!("DISCORD_TOKEN"), ffmpeg: nil, gateway_intents: :all
