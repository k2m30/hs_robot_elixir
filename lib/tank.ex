# alias ElixirALE.GPIO
defmodule Tank do

  def forward do
    IO.puts "W"
  end

  def backward do
    IO.puts "S"
  end

  def left do
    IO.puts "A"
  end

  def right do
    IO.puts "D"
  end

  def stop do
    IO.puts "Space"
  end

  def write(pid, value) do
    GPIO.write(pid, value)
    {:ok, pid}
  end


  def init do
  end

end
