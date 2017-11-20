module Updates.Master exposing (..)

import Models.Models exposing (..)
import Queue exposing (..)
import Html exposing (Html, text)
import Time exposing (Time, inSeconds)
import Keyboard exposing (KeyCode)
import Updates.Actions exposing (curryActions)
import Views.GameGrid exposing (..)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        (newModel, newMsg) = updateWithoutCurrying msg model 
    in
        (curryModel newModel, newMsg)


updateWithoutCurrying : Msg -> Model -> ( Model, Cmd Msg )
updateWithoutCurrying msg model =
    let 
        actions = curryActions model
    in
        case msg of
            TimeUpdate time ->
                (timeUpdate (inSeconds time) model, Cmd.none)    

            KeyDown keyCode ->
                ( keyDown keyCode model actions, Cmd.none )

            StartGame ->
                ( actions.playingState, Cmd.none )

-- It is a bit annoying having to set up all these initial curried things. Probably there is something better to do here. Maybe the plan of having curried functions in the view is a bad one.
initialModel : Model
initialModel =
    { level = Level 5
    , state = Welcome
    , position = Position 2 2
    , enemies = Queue.empty |> Queue.enq ( Enemy (Position 0 0) 0.0 ) |> Queue.enq ( Enemy (Position 4 4) 5.0 )
    , grid = []
    , backgroundGridElement = (\p -> Html.p[][]) 
    , playerGridElement = Html.p[][] 
    , enemyGridElement = (\e -> Html.p[][]) 
    }

-- update energy of first enemies
-- get first enemy from Queue
-- work out where it wants to move
-- it if can move then do so
-- put it back on the queue
-- check for gameover

-- can everything to work with a maybe
-- dequeue enemy, which is a maybe
-- desired position works with an actual position, just return a nothing in no position
-- if occupied takes a maybe position and returns a maybe position
-- moveEnemy function takes the maybe and returns a modified enemy if there is a position, or returns the original enemey otherwise
-- Maybe.map, Maybe.andThen

-- deque enemy
-- run move enemy
-- run energise enemy

processTopOfQueueAndReturnToQueue : Queue a -> (a -> a) -> Queue a
processTopOfQueueAndReturnToQueue queue processor =
    let
      (maybeItem, list) = Queue.deq queue
    in
      case maybeItem of
        Just item ->
            Queue.enq (processor item) list 
        Nothing ->
            list

timeUpdate : Float -> Model -> Model
timeUpdate milliseconds model  =
    { model | 
        enemies = processTopOfQueueAndReturnToQueue model.enemies (updateEnemy model milliseconds) 
    }

updateEnemy : Model -> Float -> (Enemy -> Enemy)
updateEnemy model milliseconds =
    increaseEnemyEnergy milliseconds
    >> updateEnemyPositionAndEnergy model.enemies model.position

increaseEnemyEnergy : Float -> Enemy -> Enemy
increaseEnemyEnergy milliseconds enemy =
    { enemy | energy = enemy.energy + milliseconds }

updateEnemyPositionAndEnergy : Queue Enemy -> Position -> Enemy -> Enemy
updateEnemyPositionAndEnergy  enemies playerPosition enemy =
    let 
        newPosition = desiredEnemyPosition enemy.position playerPosition
    in
        if (enemy.energy < 2) || (isOccupied newPosition enemies == True) then
            enemy
        else
            { enemy |
                position = newPosition 
                , energy = 0 }

desiredEnemyPosition : Position -> Position -> Position
desiredEnemyPosition enemyPosition playerPosition =
    Position 
        (moveTowards enemyPosition.x playerPosition.x)
        (moveTowards enemyPosition.y playerPosition.y)

moveTowards : Int -> Int -> Int
moveTowards current target =
    if current > target then
        current - 1
    else if current < target then
        current + 1
    else
        current

isOccupied : Position -> Queue Enemy -> Bool
isOccupied position enemies =
    List.any (enemyPositionEqual position) (Queue.toList enemies)

enemyPositionEqual : Position -> Enemy -> Bool
enemyPositionEqual position enemy =
    positionsEqual position enemy.position

positionsEqual : Position -> Position -> Bool
positionsEqual position1 position2 =
    position1.x == position2.x && position1.y == position2.y

keyDown : KeyCode -> Model -> Actions -> Model
keyDown keyCode model actions  =
    case keyCode of
        37 ->
                actions.moveLeft 
        39 ->
                actions.moveRight
        38 ->
                actions.moveUp 
        40 ->
                actions.moveDown 
        27 ->
                actions.playingState
        _ ->
                model

