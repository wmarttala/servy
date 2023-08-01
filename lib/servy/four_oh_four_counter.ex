defmodule Servy.FourOhFourCounter do

  @name __MODULE__

  # Client Interface

  def start(initial_state \\ %{}) do
    IO.puts "Starting the 404 counter..."
    pid = spawn(__MODULE__, :listen_loop, [initial_state])
    Process.register(pid, @name)
    pid
  end

  def bump_count(path) do
    send @name, {self(), :bump_count, path}

    receive do {:response, count} -> count end
  end

  def get_count(path) do
    send @name, {self(), :get_count, path}

    receive do {:response, count} -> count end
  end

  def get_counts do
    send @name, {self(), :get_counts}

    receive do {:response, counts} -> counts end
  end

  # Server

  def listen_loop(state) do
    receive do
      {sender, :bump_count, path} ->
        new_state = Map.update(state, path, 1, &(&1 + 1))
        send sender, {:response, Map.get(new_state, path)}
        listen_loop(new_state)
      {sender, :get_count, path} ->
        count = Map.get(state, path, 0)
        send sender, {:response, count}
        listen_loop(state)
      {sender, :get_counts} ->
        send sender, {:response, state}
        listen_loop(state)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state)
    end
  end

end
