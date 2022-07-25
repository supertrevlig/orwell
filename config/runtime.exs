import Config

if System.get_env("PORT") do
  config :orwell, port: String.to_integer(System.get_env("PORT"))
end

if System.get_env("LOG_FILE") do
  config :orwell, log_file: System.get_env("LOG_FILE")
end
