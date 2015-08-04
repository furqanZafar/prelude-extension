{filter, find, map, partition, reverse, sort-by} = require \prelude-ls

# clamp :: Number -> Number -> Number
clamp = (n, min, max) --> Math.max min, (Math.min max, n)

# find-all :: String -> String -> Int -> [Int]
find-all = (text, search, offset) -->
    index = text .substr offset .index-of search
    if index == -1
        [] 
    else
        [offset + index] ++ (find-all text, search, (offset + index + search.length))

# partition-string :: String -> String -> [[Int, Int, Bool]]
partition-string = (text, search) -->
    return [[0, text.length]] if search.length == 0
    [first, ..., x]:indices = find-all text, search, 0
    return [] if indices.length == 0
    last = x + search.length
    high = indices
        |> map -> [it, it + search.length, true]
    low = [0 til high.length - 1]
        |> map (i) ->
            [high[i].1, high[i + 1].0, false]
    (if first == 0 then [] else [[0, first, false]]) ++
    ((high ++ low) |> sort-by (.0)) ++
    (if last == text.length then [] else [[last, text.length, false]])

module.exports = {clamp, find-all, partition-string}