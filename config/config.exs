import Config

config :orwell,
  log_file: "/tmp/orwell.log",
  log_writer: Orwell.LogWriter.Impl,
  id_server: Orwell.IDServer.Random,
  orwell: Orwell.Impl,
  port: 4001

import_config "#{config_env()}.exs"
