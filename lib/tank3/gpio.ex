defmodule Tank.GPIO do
    def write(pin, value) do
        IO.puts value
        {:ok, pin}
    end
  
    def start_link(pin, direction) do
        {:ok, pin}
    end
  
end  