defmodule Pista.Workers.LiveDetectorRedbullWorker do
  use GenServer

  require Logger

  # Client
  def redbulltv_is_live?() do
    GenServer.call({:global, __MODULE__}, :get_livestreams)
  end

  # Server

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{results: false}, name: {:global, __MODULE__})
  end

  @impl true
  def init(state) do
    state = do_work(state)
    schedule_work()

    {:ok, state}
  end

  @impl true
  def handle_call(:get_livestreams, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_info(:work, state) do
    state = do_work(state)

    schedule_work()

    {:noreply, state}
  end

  defp schedule_work do
    Process.send_after(self(), :work, :timer.minutes(20))
  end

  defp do_work(_state) do
    Pista.Livestreams.check_live_redbull_tv()
  end
end
