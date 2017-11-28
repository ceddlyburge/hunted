module Updates.Master exposing (..)

import Updates.PlayerActions exposing (curryPlayerActions)
import Updates.Enemies exposing (updateEnemies, isOccupiedByEnemy)
import Views.GameGrid exposing (..)
import Models.Models exposing (..)
import Models.Position exposing (..)

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
    case msg of
        TimeUpdate time ->
            (timeUpdate (inSeconds time) model, Cmd.none)    

        KeyDown keyCode ->
            ( keyDown keyCode model (curryPlayerActions model), Cmd.none )

        StartGame ->
            ( { model | state = Playing }, Cmd.none)

        ShowWelcome ->
            ( initialModel, Cmd.none)

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
                { model | state = Playing }
        _ ->
                model

timeUpdate : Float -> Model -> Model
timeUpdate milliseconds model  =
      case model.state of
        Playing ->
            updateEnemies milliseconds model
            |> checkGameOver
        _ ->
            model 

checkGameOver : Model -> Model
checkGameOver model =
    if isOccupiedByEnemy model.position model.enemies then
        { model | state = GameOver }
    else
        model

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
