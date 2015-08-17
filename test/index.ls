assert = require \assert
{clamp, find-all, get, is-equal-to-object, mappend, partition-string, rextend, set, transpose} = require \../index

describe "prelude-extension", ->

    specify "clamp", ->
        assert (clamp 1.2, 0, 1) == 1
        assert (clamp 0.2, 0.5, 1) == 0.5

    str = "hip hop hip hop"

    specify "find-all", ->
        indices = find-all str, \hip, 0
        assert indices.length == 2
        assert indices.0 == 0
        assert indices.1 == 8

    specify "get", ->
        population = asia: china: singapore: 539900
        assert (get population, <[asia china singapore]>) == 539900

    specify "is-equal-to-object", ->
        o1 = {a: {b: 1, c: 1}, d: 2}
        o2 = {a: {b: 1, c: 1}, d: 2}
        assert o1 `is-equal-to-object` o2
        o1 = [1,2,3]
        o2 = [1,2,3]
        assert o1 `is-equal-to-object` o2
        o1 = \apple
        o2 = \apple
        assert o1 `is-equal-to-object` o2
        o1 = {a: {b: {c: 1}}}
        o2 = {a: {b: 1}}
        assert !(o1 `is-equal-to-object` o2)
        o1 = [1,2,3]
        o2 = [1,"2",3]
        assert !(o1 `is-equal-to-object` o2)

    specify "mappend", ->
        stats = {users: {"40": {visits: 2}}}
        mappend stats, <[users 40]>, {visits: 1}, (a, b) -> {visits: a.visits + b.visits}
        assert stats.users["40"].visits == 3

    specify "partition-string", ->
        partitions = partition-string str, \hip
        assert partitions.length == 4

        # the first partition ([0, 3, true])
        assert partitions.0.0 == 0
        assert partitions.0.1 == 3
        assert partitions.0.2 == true

        # the second partition ([3, 8, false])
        assert partitions.1.2 == false

        # the third partition ([8, 11, true])
        assert partitions.2.0 == 8
        assert partitions.2.1 == 11
        assert partitions.2.2 == true

    specify "rextend", ->
        obj = {a: {x: 1, y: 1}}
        result = rextend obj, {a: {x: 2}}
        assert result.a.y == 1

    specify "set", ->
        users = {"40": {address: {country: "ae"}}}
        result = set users, <[40 address country]>, \us
        assert users["40"].address.country == \us

    specify "transpose", ->
        assert (transpose [[1,2], [3,4]]) `is-equal-to-object` [[1,3], [2,4]]
