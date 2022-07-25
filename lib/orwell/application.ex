defmodule Orwell.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @id_server Application.fetch_env!(:orwell, :id_server)

  def start(_type, _args) do
    # List all child processes to be supervised

    log_file = Application.fetch_env!(:orwell, :log_file)
    port = Application.fetch_env!(:orwell, :port)

    children = [
      {@id_server, name: Orwell.IDServer},
      {Orwell.LogServer, log_file: log_file, name: Orwell.LogServer},
      {Plug.Cowboy, scheme: :http, plug: OrwellWeb.Plugs.Router, options: [port: port]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Orwell.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
