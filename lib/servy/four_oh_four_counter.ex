defmodule Servy.FourOhFourCounter do

  @name :four_oh_four_counter

  alias Servy.GenericServer

  # Client Interface

  def start(initial_state \\ %{}) do
    IO.puts "Starting the 404 counter..."
    GenericServer.start(__MODULE__, initial_state, @name)
  end

  def bump_count(path) do
    GenericServer.call @name, {:bump_count, path}
  end

  def get_count(path) do
    GenericServer.call @name, {:get_count, path}
  end

  def get_counts do
    GenericServer.call @name, :get_counts
  end

  def reset do
    GenericServer.cast @name, :reset
  end

  # Server

  def handle_call({:bump_count, path}, state) do
    new_state = Map.update(state, path, 1, &(&1 + 1))
    {Map.get(new_state, path), new_state}
  end

  def handle_call({:get_count, path}, state) do
    count = Map.get(state, path, 0)
    {count, state}
  end

  def handle_call(:get_counts, state) do
    {state, state}
  end

  def handle_cast(:reset, _state) do
    %{}
  end

end
