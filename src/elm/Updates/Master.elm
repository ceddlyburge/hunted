module Updates.Master exposing (..)

import Updates.Actions exposing (curryActions)
import Updates.Enemies exposing (updateEnemy)
import Views.GameGrid exposing (..)
import Models.Models exposing (..)

import Queue exposing (..)
import Html exposing (Html, text)
import Time exposing (Time, inSeconds)
import Keyboard exposing (KeyCode)

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

            ShowWelcome ->
                ( actions.welcomeState, Cmd.none )

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

timeUpdate : Float -> Model -> Model
timeUpdate milliseconds model  =
      case model.state of
        Playing ->
            { model | 
            enemies = processTopOfQueueAndReturnToQueue model.enemies (updateEnemy model milliseconds)
            , state = checkGameOver model }
        _ ->
            model

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


checkGameOver : Model -> State
checkGameOver model =
    if isOccupied model.position model.enemies == False then
        Playing
    else
        GameOver

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

