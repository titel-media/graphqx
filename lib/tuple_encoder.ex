defimpl Poison.Encoder, for: Tuple do
  alias Poison.Encoder

  def encode(tuple, options) when is_tuple(tuple) do
    Encoder.List.encode(Tuple.to_list(tuple), options)
  end
end
