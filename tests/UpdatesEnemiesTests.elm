module UpdatesEnemiesTests exposing (..)

import Test exposing (..)
import Fuzz exposing (int, intRange)
import Random exposing (maxInt)
import Expect
import Queue exposing (..)

import Models.Enemy exposing (..)
import Models.Position exposing (..)
import Updates.Enemies exposing (..)
import Models.Models exposing (Model, Level, State)
import Html exposing (Html, text)


--updateEnemies : Float -> Model -> Model
--updateEnemies milliseconds model =
--    { model | enemies = processTopOfQueueAndReturnToQueue model.enemies (updateEnemy model milliseconds) }
-- takes first enemy from the queue, potentially moves it and resets energy, or does nothing, then adds back at end of queue
-- that is quite a lot to test
-- want to test via the public interface, but this makes it hard to do anything simple
-- are there any fuzz type tests I could use?
--  enemy at front of queue always at end of queue afterwards
--  enemy with energy below threshold doesn't move and energy increases by the milliseconds amount
--  enemy with energy above threshold moves towards model position (maybe just have one enemy for this)

updateEnemiesTests : Test
updateEnemiesTests  =
    describe "updateEnemies"
        [   fuzz (intRange 0 50) "Enemy at front of queue returned to back" <|
            \(enemyCount) ->
                let
                    enemy = anyEnemy
                in
                Queue.empty
                |> Queue.enq enemy
                |> Queue.enqMany anyEnemy 10
                |> \enemies -> updateEnemies 0 { anyModel | enemies = enemies }
                |> \model -> model.enemies
                |> Queue.toList
                |> List.reverse
                |> List.head
                |> Expect.equal (Just enemy)
        ]


anyEnemy : Enemy
anyEnemy = Enemy (Position 0 0) 0

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
        , fuzz3 int int (intRange 1 Random.maxInt) "unoccupied" <|
            \x y delta ->
                Queue.empty
                |> Queue.enq (enemyWithPosition (x + delta) (y + delta))
                |> Queue.enq (enemyWithPosition (x - delta) (y - delta))
                |> Queue.enq (enemyWithPosition (x + delta) (y - delta))
                |> Queue.enq (enemyWithPosition (x - delta) (y + delta))
                |> \enemies -> isOccupiedByEnemy (Position x y) enemies
                |> Expect.equal False
        ]

enemyWithPosition : Int -> Int -> Enemy
enemyWithPosition x y  = 
    Enemy (Position x y) 0

-- this is an annoyance, Model has a lot of dependencies
anyModel : Model
anyModel =
    { level = Level 0
    , state = Models.Models.Welcome
    , position = Position 0 0
    , enemies = Queue.empty
    , grid = []
    , backgroundGridElement = (\p -> Html.p [] [])
    , playerGridElement = Html.p [] []
    , enemyGridElement = (\e -> Html.p [] [])
    }