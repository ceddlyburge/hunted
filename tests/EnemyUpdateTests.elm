module EnemyUpdateTests exposing (..)

import Test exposing (..)
import Fuzz exposing (float, int, string)
import Expect
import Models.Enemy exposing (..)
import Models.Position exposing (..)
import Updates.EnemyUpdate exposing (..)

-- map takes an enemy -> enemy function, and returns a enemyUpdate -> enemyUpdate function. The returned function applies the passed function to the enemy parameter of the enemyUpdate
-- this isn't a functor I think, as a functor would be able to work with a function that takes a value and returns anything, whereas this requires that it return an enemy.
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
    
-- map takes an Value -> Value function, and returns a (ValueAndContext Value a)-> (ValueAndContext Value a) function. The returned function applies the passed function to the value parameter of the ValueAndContext
-- valueAndContextMapTest : Test
-- valueAndContextMapTest  =
--     describe "map2"
--         [ fuzz2 float string "map applies function to value and leaves context unchanged" <|
--             \value context ->
--                 let
--                     functionToMap = \x -> x / 2
--                 in
--                     ValueAndContext value context
--                     |> Updates.EnemyUpdate.mapValueAndContext functionToMap
--                     |> Expect.equal (ValueAndContext (functionToMap value) context)
--         ]

-- mapReturn takes an enemyupdate -> enemy function, and returns a enemyUpdate -> enemyUpdate function. The returned function applies the passed function to the enemy parameter if enemyUpdate
-- what is this in functional language, if anything.
-- EnemyUpdate is the container, and Enemy is the simple value inside it
-- function takes a container and returns a simple value
-- mapTest : Test
-- mapTest  =
--     describe "map"
--         [ fuzz3 float int int "map applies function to Enemy and leave positions unchanged" <|
--             \energy x y ->
--                 let
--                     enemyFunction = \enemy -> { enemy | energy = energy}
--                     position = Position x y
--                 in
--                 enemyWithAllZeros
--                 |> \enemy -> EnemyUpdate enemy position position
--                 |> Updates.EnemyUpdate.map enemyFunction
--                 |> Expect.equal (EnemyUpdate (enemyFunction enemyWithAllZeros) position position)
--        ]

enemyWithAllZeros : Enemy
enemyWithAllZeros = Enemy (Position 0 0) 0
