# Map
() ->
  emit this.message.user_agent, 1

# Reduce
(key, values) ->
  total = 0
  for v in values
    total += values[v]
  return total
