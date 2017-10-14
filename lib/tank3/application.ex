defmodule Tank.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  use Supervisor

    def start(_type, _args) do      

      children = [
        worker(__MODULE__, [], function: :run)
      ]
  
      opts = [strategy: :one_for_one, name: Tank.Supervisor]
      Supervisor.start_link(children, opts)
    end
  
    def run do
      gpio_init()
      
      routes = [
        {"/", Tank.Root, []},
        # {"/static/[...]", :cowboy_static, {:priv_dir, :tank, "js"}},
        {"/js/main.js", Tank.Js, []},
        {"/action", Tank.Action, []}
      ]
  
      dispatch = :cowboy_router.compile([{:_, routes}])
  
      opts = [port: 8000]
      env = [dispatch: dispatch]
  
      {:ok, _pid} = :cowboy.start_http(:http, 100, opts, [env: env])
    end

    def gpio_init do
      
    end
end
