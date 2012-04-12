# Map
() ->
  emit this.something, 1

# Reduce
(key, values) ->
  total = 0
  for v in values
    total += values[v]
  return total

# Finalize (optional)
(key, value) ->
  return value
