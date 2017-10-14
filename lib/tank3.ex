defmodule Tank do
  @stand_by 1
  @pwm_a 0
  @pwm_b 6
  @ain_1 3
  @ain_2 2
  @bin_1 4
  @bin_2 5

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
end
