# Map
() ->
  emit this.type, 1
  return null

# Reduce
(key, values) ->
  total = 0
  for v in values
    total += values[v]
  return total
