defmodule KV.Bucket do
  @moduledoc """
    Module for bucket
  """

  @doc """
    starts a bucket and inits with an empty map
  """
  def start_link do
    Agent.start_link(fn -> %{} end)
  end

  @doc """
    get method to get the value for 
    the given key in the bucket
  """
  def get(bucket, key) do
    Agent.get(bucket, &Map.get(&1, key))
  end

  @doc """
    put will add/update the key with
    the given value
  """
  def put(bucket, key, value) do
    Agent.update(bucket, &Map.put(&1, key, value))
  end

  @doc """
    delete will remove the specified key
  """
  def delete(bucket, key) do
    Agent.get_and_update(bucket, &Map.pop(&1, key))
  end
end