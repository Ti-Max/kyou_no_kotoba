import Config

config :nostrum,
  token: System.get_env("DISCORD_TOKEN", "Mr. Token"),
  ffmpeg: nil,
  gateway_intents: [:guilds]
