defmodule Tank.Storage do
  alias Tank.GPIO
  @stand_by 1
  @pwm_a 0
  @pwm_b 6
  @ain_1 3
  @ain_2 2
  @bin_1 4
  @bin_2 5

  use GenServer
  # API
  def start_link do
    GenServer.start_link(__MODULE__, %{}, name: :storage)
  end
  def set_pids(pids) do
    GenServer.cast(:storage, {:set_pids, pids})
  end
  def get_pids() do
    GenServer.call(:storage, :get_pids)
  end

  def command(command) do
    GenServer.cast(:storage, {:command, command})
  end

  # SERVER
  def init(_) do
    {:ok, stand_by} = GPIO.start_link(@stand_by, :output)
    
    {:ok, ain_1} = GPIO.start_link(@ain_1, :output)
    {:ok, ain_2} = GPIO.start_link(@ain_2, :output)
    
    {:ok, bin_1} = GPIO.start_link(@bin_1, :output)
    {:ok, bin_2} = GPIO.start_link(@bin_2, :output)

    {:ok, pwm_a} = GPIO.start_link(@pwm_a, :output)
    {:ok, pwm_b} = GPIO.start_link(@pwm_b, :output)

    GPIO.write(stand_by, 1)
  
    {:ok, %{stand_by: stand_by, ain_1: ain_1, ain_2: ain_2, bin_1: bin_1, bin_2: bin_2, pwm_a: pwm_a, pwm_b: pwm_b} }
  
  end
  def handle_cast({:set_pids, pids}, _state) do
    {:noreply, pids}
  end

  def handle_cast({:command, command}, pids) do
    case command do
      :w -> forward(pids)
      :s -> backward(pids)
      :a -> left(pids)
      :d -> right(pids)
      :space -> stop(pids)
      _ -> IO.puts command
    end
    {:noreply, pids}
  end

  def handle_call(:get_pids, _from, pids) do
    {:reply, pids, pids}
  end

  def forward(pids) do
    left_forward(pids)
    right_forward(pids)
  end

  def backward(pids) do
    left_backward(pids)
    right_backward(pids)
  end

  def left(pids) do
    left_forward(pids)
    right_stop(pids)
  end

  def right(pids) do
    left_stop(pids)
    right_forward(pids)
  end

  def stop(pids) do
    left_stop(pids)
    right_stop(pids)
  end

  def left_forward(pids) do
    GPIO.write(pids.ain_1, 1)
    GPIO.write(pids.ain_2, 0)
    GPIO.write(pids.pwm_a, 1)
  end

  def right_forward(pids) do
    GPIO.write(pids.bin_1, 1)
    GPIO.write(pids.bin_2, 0)
    GPIO.write(pids.pwm_b, 1)
  end

  def left_backward(pids) do
    GPIO.write(pids.ain_1, 0)
    GPIO.write(pids.ain_2, 1)
    GPIO.write(pids.pwm_a, 1)
  end

  def right_backward(pids) do
    GPIO.write(pids.bin_1, 0)
    GPIO.write(pids.bin_2, 1)
    GPIO.write(pids.pwm_b, 1)
  end

  def left_stop(pids) do
    GPIO.write(pids.ain_1, 0)
    GPIO.write(pids.ain_2, 0)
    GPIO.write(pids.pwm_a, 1)
  end

  def right_stop(pids) do
    GPIO.write(pids.bin_1, 0)
    GPIO.write(pids.bin_2, 0)
    GPIO.write(pids.pwm_b, 1)
  end
  
end