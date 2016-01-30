{all, any, concat-map, each, filter, find, is-type, keys, map, Obj, obj-to-pairs, partition, reverse, sort-by} = require \prelude-ls

# clamp :: Number -> Number -> Number
clamp = (n, min, max) --> Math.max min, (Math.min max, n)

# find-all :: String -> String -> Int -> [Int]
find-all = (text, search, offset) -->
    index = text .substr offset .index-of search
    if index == -1
        [] 
    else
        [offset + index] ++ (find-all text, search, (offset + index + search.length))

# get :: a -> [String] -> b
get = (object, [p, ...ps]) -->
    if ps.length == 0
        object[p] ? null
    else
        if typeof object[p] == \undefined
            null
        else
            get object[p], ps

# is-empty-object :: object -> Boolean
is-empty-object = (o) ->
    number-of-keys = o 
        |> Obj.filter -> !!it
        |> keys
        |> (.length)
    number-of-keys == 0

# is-equal-to-object :: a -> b -> Boolean
is-equal-to-object = (o1, o2) -->
    return false if (typeof! o1) != (typeof! o2)
    return o1 == o2 if <[Boolean Number String undefined]> |> any -> is-type it, o1
    if typeof! o1 == \Array
        return false if o1.length != o2.length
        [0 til o1.length] |> all (index) -> o1[index] `is-equal-to-object` o2[index]
    else
        (keys o1) |> all (key) ->
            if (is-type \Object, o1[key]) or (is-type \Array, o1[key])
                o1[key] `is-equal-to-object` o2[key]
            else
                o1[key] == o2[key]

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

# mappend :: a -> [String] -> b -> (b -> b -> b) -> a (MUTATION)
mappend = (object, path, next-value, combinator) -->
    current = get object, path
    set object, path, (if !!current then (combinator current, next-value) else next-value)

# rextend :: a -> b -> c
rextend = (a, b) -->

    # return b if its not an object
    btype = typeof! b
    return b if any (== btype), <[Boolean Number String Function]>

    # return b if a is null or undefined
    return b if a is null or (\Undefined == typeof! a)

    # return a if b is an empty object
    bkeys = Obj.keys b
    return a if bkeys.length == 0

    # copy b's keys and values to a
    bkeys |> each (key) ->
        a[key] = (if (Obj.keys a[key]).length > 0 then {} <<< a[key] else a[key]) `rextend` b[key]
        
    a

# set :: a -> [String] -> b -> a (MUTATION)
set = (object, [p, ...ps], value) -->
    if ps.length > 0
        object[p] = object[p] ? {}
        set object[p], ps, value
    else
        object[p] = value
        object

# transpose :: [[a]] -> [[a]]
transpose = (arr) ->
    keys arr.0
        |> map (column) ->
            arr |> map (row) -> row[column]

# unwrap :: ([String] -> a -> b) -> Int -> c -> [b]
unwrap = (f, depth, object) --> 
    r = (f, ks, i, j, object) -->
        object
            |> obj-to-pairs
            |> concat-map ([k, v]) -> if i < j then r f, (ks ++ k), (i + 1), j, v else f (ks ++ k), v
    r f, [], 0, depth, object

module.exports = {
    clamp, find-all, get, is-empty-object, is-equal-to-object, mappend, partition-string, rextend, set, transpose, unwrap
}