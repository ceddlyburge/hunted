module EnemyUpdateTests exposing (..)

import Test exposing (..)
import Fuzz exposing (float, int)
import Expect
import Models.Enemy exposing (..)
import Models.Position exposing (..)
import Updates.EnemyUpdate exposing (..)

-- map takes an enemy -> enemy function, and returns a enemyUpdate -> enemyUpdate function. The returned function applies the passed function to the enemy parameter if enemyUpdate
mapTest : Test
mapTest  =
    describe "map"
        [ fuzz3 float int int "map applies function to Enemy and leave positions unchanged" <|
            \energy x y ->
                let
                    enemyFunction = \enemy -> { enemy | energy = energy}
                    position = Position x y
                in
                enemyWithAllZeros
                |> \enemy -> EnemyUpdate enemy position position
                |> Updates.EnemyUpdate.map enemyFunction
                |> Expect.equal (EnemyUpdate (enemyFunction enemyWithAllZeros) position position)
        ]
    

enemyWithAllZeros : Enemy
enemyWithAllZeros = Enemy (Position 0 0) 0
