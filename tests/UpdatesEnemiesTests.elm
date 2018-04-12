module UpdatesEnemiesTests exposing (..)

import Test exposing (..)
import Fuzz exposing (int)
import Expect
import Queue exposing (..)

import Models.Enemy exposing (..)
import Models.Position exposing (..)
import Updates.Enemies exposing (..)


--updateEnemies, isOccupiedByEnemy are the public functions

isOccupiedByEnemyTests : Test
isOccupiedByEnemyTests  =
    describe "isOccupiedByEnemy"
        [ fuzz2 int int  "occupied" <|
            \x y ->
                Queue.empty
                |> Queue.enq (enemyWithPosition 0 0)
                |> Queue.enq (enemyWithPosition x y)
                |> \enemies -> isOccupiedByEnemy (Position x y) enemies
                |> Expect.equal True
        , fuzz2 int int  "unoccupied" <|
            \x y ->
                Queue.empty
                |> Queue.enq (enemyWithPosition x y)
                |> Queue.enq (enemyWithPosition (x + 1) (y + 1))
                |> \enemies -> isOccupiedByEnemy (Position (x + 2) (y + 2)) enemies
                |> Expect.equal False
        ]

enemyWithPosition : Int -> Int -> Enemy
enemyWithPosition x y  = 
    Enemy (Position x y) 0
