module PositionTests exposing (..)

import Test exposing (..)
import Expect
import Models.Position exposing (..)


position : Test
position  =
    describe "equals"
        [ test "equal when x and y are the same" <|
            \() ->
                equals (Position 3 6) (Position 3 6)
                    |> Expect.equal True
        , test "not equal if x different" <|
            \() ->
                equals (Position 3 6) (Position 4 6)
                    |> Expect.equal False
        , test "not equal if y different" <|
            \() ->
                equals (Position 3 6) (Position 3 7)
                    |> Expect.equal False
        ]
