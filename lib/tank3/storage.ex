defmodule Tank.Storage do
  # use ElixirALE.GPIO
  # alias Tank.GPIO
  alias ElixirALE.GPIO
  @stand_by 25 #6
  @pwm_a 19 #24
  @pwm_b 18 #1
  @ain_1 22 #3
  @ain_2 27 #2
  @bin_1 23 #4
  @bin_2 24 #5

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
  
    {:ok, %{stand_by: stand_by, ain_1: ain_1, ain_2: ain_2, bin_1: bin_1, bin_2: bin_2, pwm_a: pwm_a, pwm_b: pwm_b, state: :stop, is_on: true} }
  
  end
  
  def handle_cast({:set_pids, pids}, _state) do
    {:noreply, pids}
  end

  def handle_cast({:command, command}, pids) do
    if command != pids.state do
      IO.puts command
      IO.puts pids.state
      case command do
        :w -> new_pids = forward(pids)
        :s -> new_pids = backward(pids)
        :a -> new_pids = left(pids)
        :d -> new_pids = right(pids)
        :p -> new_pids = stand_by(pids)
        :space -> new_pids = stop(pids)
        _ -> IO.puts command
      end      
      IO.inspect readall(new_pids)
      {:noreply, new_pids}
    else
      # IO.puts "Same state"
      {:noreply, pids}
    end
    
  end

  def handle_call(:get_pids, _from, pids) do
    {:reply, pids, pids}
  end

  def handle_call(:readall, _from, pids) do    
    {:reply, readall(pids), pids}
  end

  #/////////////////////////
  def readall(pids) do
    %{stand_by: GPIO.read(pids.stand_by), ain_1: GPIO.read(pids.ain_1), ain_2: GPIO.read(pids.ain_2), bin_1: GPIO.read(pids.bin_1), bin_2: GPIO.read(pids.bin_2), pwm_a: GPIO.read(pids.pwm_a), pwm_b: GPIO.read(pids.pwm_b) }
  end
  #/////////////////////////

  def forward(pids) do
    left_forward(pids)
    right_forward(pids)
    Map.put(pids, :state, :w)
  end

  def backward(pids) do
    left_backward(pids)
    right_backward(pids)
    Map.put(pids, :state, :s)
  end

  def left(pids) do
    left_stop(pids)
    right_forward(pids)
    Map.put(pids, :state, :a)
  end

  def right(pids) do
    left_forward(pids)
    right_stop(pids)
    Map.put(pids, :state, :d)
  end

  def stop(pids) do
    left_stop(pids)
    right_stop(pids)
    Map.put(pids, :state, :space)
  end

#/////////////////////////////

  def left_forward(pids) do
    GPIO.write(pids.ain_1, 0)
    GPIO.write(pids.ain_2, 1)
    GPIO.write(pids.pwm_a, 1)
  end

  def right_forward(pids) do
    GPIO.write(pids.bin_1, 0)
    GPIO.write(pids.bin_2, 1)
    GPIO.write(pids.pwm_b, 1)
  end

  def left_backward(pids) do
    GPIO.write(pids.ain_1, 1)
    GPIO.write(pids.ain_2, 0)
    GPIO.write(pids.pwm_a, 1)
  end

  def right_backward(pids) do
    GPIO.write(pids.bin_1, 1)
    GPIO.write(pids.bin_2, 0)
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

  def stand_by(pids) do
    case pids.is_on do
       true -> GPIO.write(pids.stand_by, false)
       _ -> GPIO.write(pids.stand_by, true)
    end    
    Map.put(pids, :state, :stand_by)
    |> Map.put(:is_on, !pids.is_on)
  end
  
end