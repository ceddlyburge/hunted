module EnemyTests exposing (..)

import Test exposing (..)
import Fuzz exposing (float, int)
import Expect
import Models.Enemy exposing (..)
import Models.Position exposing (..)


resetEnergyTest : Test
resetEnergyTest  =
    describe "resetEnergy"
        [ fuzz float "resetEnergy sets energy to zero" <|
            \energy ->
                anyEnemy
                |> \enemy -> { enemy | energy = energy }
                |> resetEnergy
                |> \enemy -> enemy.energy
                |> Expect.equal 0
        ]
    
setPositionTest : Test
setPositionTest  =
    describe "setPosition"
        [ fuzz2 int int "setPosition sets position property on enemy" <|
            \x y ->
                anyEnemy
                |> \enemy -> setPosition enemy (Position x y)
                |> \enemy -> enemy.position
                |> Expect.equal (Position x y)
        ]

positionsEqualTest : Test
positionsEqualTest  =
    describe "positionsEqual"
        [ fuzz2 int int "positionsEqual uses position property on enemy" <|
            \x y ->
                anyEnemy
                |> \enemy -> setPosition enemy (Position x y)
                |> positionsEqual (Position x y) 
                |> Expect.equal True
        ]

anyEnemy : Enemy
anyEnemy = Enemy (Position 0 0) 0
