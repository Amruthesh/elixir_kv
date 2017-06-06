defmodule KV.Registry do
  @moduledoc """
    module for registry
  """
  use GenServer

  @doc """
    Client APIs
    init the registry
  """
  def start_link do
    GenServer.start_link(__MODULE__, :ok, [])
  end

  @doc """
    create the bucket with the given name
    in the specified server
  """
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  @doc """
    look up the specified bucket in the
    specified server
  """
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
    Server callbacks
  
    init the server
  """
  def init(:ok) do
    names = %{}
    refs = %{}
    {:ok, {names, refs}}
  end

  @doc """
    handle call for look up with name of bucket
  """
  def handle_call({:lookup, name}, _from, {names, _} = state) do
    {:reply, Map.fetch(names, name), state}
  end

  @doc """
    creates the bucket if not there
  """
  def handle_cast({:create, name}, {names, refs}) do
    if Map.has_key?(names, name) do
      {:noreply, {names, refs}}
    else
      {:ok, pid} = KV.Bucket.start_link
      ref = Process.monitor(pid)
      refs = Map.put(refs, ref, name)
      names = Map.put(names, name, pid)
      {:noreply, {names, refs}}
    end
  end

  @doc """
    handle info when down signal
  """
  def handle_info({:DOWN, ref, :process, _pid, _reason}, {names, refs}) do
    {name, refs} = Map.pop(refs, ref)
    names = Map.delete(names, name)
    {:noreply, {names, refs}}
  end

  @doc """
    when it is not a down signal
  """
  def handle_info(_msg, state) do
    {:noreply, state}
  end

  @doc """
    stop the genserver
  """
  def stop(server) do
    GenServer.stop(server)
  end
end