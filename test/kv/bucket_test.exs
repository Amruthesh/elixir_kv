defmodule KV.BucketTest do
  use ExUnit.Case, async: true

  test "stores value by keys" do
    {:ok, bucket} = KV.Bucket.start_link
    assert KV.Bucket.get(bucket, "eggs") == nil

    KV.Bucket.put(bucket, "eggs", 12)
    assert KV.Bucket.get(bucket, "eggs") == 12

    KV.Bucket.delete(bucket, "eggs")
    assert KV.Bucket.get(bucket, "eggs") == nil
  end
end