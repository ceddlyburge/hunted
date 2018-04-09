module EnemyTests exposing (..)

import Test exposing (..)
import Expect
import Models.Enemy exposing (..)
import Models.Position exposing (..)


position : Test
position  =
    describe "resetEnergy"
        [ test "resetEnergy sets energy to zero" <|
            \() ->
                resetEnergy (Enemy (Position 1 1) 6)
                    |> \enemy -> enemy.energy
                    |> Expect.equal 0
        ]
