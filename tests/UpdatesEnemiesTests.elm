module UpdatesEnemiesTests exposing (..)

import Test exposing (..)
import Fuzz exposing (Fuzzer, int, intRange, floatRange, oneOf, constant)
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
-- enemy with energy above threshold moves towards model position (maybe just have one enemy for this)
   -- fuzzing
   -- can put the enemy anywhere
   -- and the player anywhere else
   -- need to make sure that these aren't the same
   -- fuzz testing maybe not the best for this, could describe the algorithm in the tests
      -- eg always move in direction of player, even if it is a long way away in one direction, but close in another
        -- move diagonally
        -- move in each of four directions
-- enemy can't move although it wants to because another enemy in the way
   -- isoccupied already tested, so can use it
   -- can probably fuzz this and force cases where it is going to be blocked quite a bit of the time

updateEnemiesTests : Test
updateEnemiesTests  =
    describe "updateEnemies"
        [   fuzz (intRange 0 50) "Enemy at front of queue returned to back" <|
            \enemyCount ->
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
            ,fuzz (floatRange 0 1.89) "Not enough energy to move" <|
            \energy ->
                let
                    originalEnemy = enemyWithEnergy energy
                    energyIncrement = 0.1
                in
                Queue.empty
                |> Queue.enq originalEnemy
                |> \enemies -> updateEnemies energyIncrement { anyModel | enemies = enemies }
                |> \model -> model.enemies
                |> Queue.deq
                |> \(maybeEnemy, queue) -> Maybe.map positionAndEnergy maybeEnemy
                |> Expect.equal (Just (PositionAndEnergy originalEnemy.position (originalEnemy.energy + energyIncrement)))
            ,fuzz5 int (intRange 1 5) (intRange 100 500) oneOrMinusOne oneOrMinusOne "Move closer to player in x and y directions, regardless of relative distance" <|
            \xy deltaX deltaY signX signY ->
                let
                    originalEnemy = enemyWithEnoughEnergyToMoveAndPosition (xy + (deltaX * signX)) (xy + (deltaY * signY))
                    playerPosition = Position xy xy
                in
                Queue.empty
                |> Queue.enq originalEnemy
                |> \enemies -> updateEnemies 0 { anyModel | enemies = enemies, position = playerPosition }
                |> \model -> model.enemies
                |> Queue.deq
                |> \(maybeEnemy, queue) -> Maybe.map (\enemy -> enemy.position) maybeEnemy
                |> Expect.equal (Just (Position (originalEnemy.position.x - signX) (originalEnemy.position.y - signY)))
        ]


isOccupiedByEnemyTests : Test
isOccupiedByEnemyTests  =
    describe "isOccupiedByEnemy"
        [ fuzz2 int int  "occupied" <|
            \x y ->
                Queue.empty
                |> Queue.enq (enemyWithPosition 0 0)
                |> Queue.enq (enemyWithPosition x y)
                |> isOccupiedByEnemy (Position x y)
                |> Expect.equal True
        , fuzz3 int int (intRange 1 Random.maxInt) "unoccupied" <|
            \x y delta ->
                Queue.empty
                |> Queue.enq (enemyWithPosition (x + delta) (y + delta))
                |> Queue.enq (enemyWithPosition (x - delta) (y - delta))
                |> Queue.enq (enemyWithPosition (x + delta) (y - delta))
                |> Queue.enq (enemyWithPosition (x - delta) (y + delta))
                |> isOccupiedByEnemy (Position x y)
                |> Expect.equal False
        ]

type alias PositionAndEnergy =
    {
        position : Position
        , energy : Float
    }

anyEnemy : Enemy
anyEnemy = Enemy (Position 0 0) 0

enemyWithEnoughEnergyToMoveAndPosition : Int -> Int -> Enemy
enemyWithEnoughEnergyToMoveAndPosition x y  = 
    Enemy (Position x y) 2

enemyWithPosition : Int -> Int -> Enemy
enemyWithPosition x y  = 
    Enemy (Position x y) 0

enemyWithEnergy : Float -> Enemy
enemyWithEnergy energy  = 
    Enemy (Position 0 0 ) energy

positionAndEnergy : Enemy -> PositionAndEnergy
positionAndEnergy enemy =
    PositionAndEnergy enemy.position enemy.energy

oneOrMinusOne : Fuzzer Int
oneOrMinusOne = 
    oneOf [constant 1, constant -1]

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