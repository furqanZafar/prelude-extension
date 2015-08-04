assert = require \assert
{clamp, find-all, map, partition-string} = require \../index

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
