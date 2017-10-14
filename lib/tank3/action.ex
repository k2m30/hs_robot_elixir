defmodule Tank.Action do
    def init({:tcp, :http}, req, opts) do
        # IO.inspect(req)
        # IO.puts(tuple_size(req))
        {_, _, _, _, _, _, _, _, _, _, _, _, _, query, _, _, _, _, _, _, _, _, _, _, _, _, _, _} = req
        # IO.inspect(query)
        commands = URI.decode_query(query)
        
        # IO.inspect query      
        IO.inspect commands
        case commands["command"] do
            nil -> IO.puts "nil detected"
            "87" -> Tank.forward  # "forward"
            "83" -> Tank.backward # "backward"
            "65" -> Tank.left     # "left"
            "68" -> Tank.right    # "right"
            "32" -> Tank.stop     # "stop"
            command -> IO.puts command
        end
        headers = [{"content-type", "text/html"}]
        {:ok, body} = {:ok, "ok"}
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