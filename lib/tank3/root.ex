defmodule Tank.Root do
    def init({:tcp, :http}, req, opts) do
      IO.inspect req
      IO.inspect opts      
      
      headers = [{"content-type", "text/html"}]
      {:ok, body} = File.read("public/main.html")            
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