defmodule SafeInspect do
  @moduledoc """
  Use this instead of normal `inspect`. Redacts sensitive data that we don't want in logs.
  """

  @redacted_keys :safe_inspect
                 |> Application.compile_env!(:redacted_keys)
                 |> Enum.map(fn k -> k |> to_string() |> String.downcase() end)

  @all_redacted_keys @redacted_keys ++
                       Enum.map(@redacted_keys, &String.replace(&1, "_", "-")) ++
                       Enum.map(@redacted_keys, &String.replace(&1, "_", ""))

  @spec inspect!(any(), keyword()) :: String.t()
  def inspect!(value, opts \\ []) do
    inspect(clean(value), opts)
  end

  defp clean(struct) when is_struct(struct) do
    struct
    |> Map.from_struct()
    |> clean()
    |> Map.put(:__struct__, struct.__struct__)
  end

  defp clean(map) when is_map(map) do
    map
    |> Enum.map(fn {k, v} ->
      if k_to_string(k) in @all_redacted_keys, do: {k, :redacted}, else: {k, clean(v)}
    end)
    |> Enum.into(%{})
  end

  defp clean({k, v}) when is_atom(k) or is_binary(k) do
    if k_to_string(k) in @all_redacted_keys do
      {k, :redacted}
    else
      {k, clean(v)}
    end
  end

  defp clean(tuple) when is_tuple(tuple) do
    tuple
    |> Tuple.to_list()
    |> clean()
    |> List.to_tuple()
  end

  defp clean(list) when is_list(list) do
    Enum.map(list, &clean/1)
  end

  defp clean(other) do
    other
  end

  defp k_to_string(k), do: k |> to_string() |> String.downcase()
end
