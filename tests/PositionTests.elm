module PositionTests exposing (..)

import Test exposing (..)
import Fuzz exposing (float, int)
import Expect
import Models.Position exposing (..)


position : Test
position  =
    describe "equals"
        [ fuzz2 int int "equal when x and y are the same" <|
            \x y ->
                equals (Position x y) (Position x y)
                    |> Expect.equal True
        , fuzz int "not equal if x different" <|
            \y ->
                equals (Position 3 y) (Position 4 y)
                    |> Expect.equal False
        , fuzz int "not equal if y different" <|
            \x ->
                equals (Position x 6) (Position x 7)
                    |> Expect.equal False
        ]
