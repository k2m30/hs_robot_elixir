defmodule Tank.Js do
    def init({:tcp, :http}, req, opts) do
      
      headers = [{"content-type", "tapplication/javascript"}]
      {:ok, body} = File.read("public/js/main.js")            
      {:ok, resp} = :cowboy_req.reply(200, headers, body, req)
      {:ok, resp, opts}
    end
  
    def handle(req, state) do
      {:ok, req, state}
    end
  
    def terminate(_reason, _req, _state) do
      :ok
    end
  end