module Updates exposing (..)

import Models exposing (..)
import Time exposing (Time)
import Keyboard exposing (KeyCode)
import CurryActions exposing (curryActions)
import Util exposing (..)

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
            TimeUpdate dt ->
                ( model, Cmd.none )

            KeyDown keyCode ->
                ( keyDown keyCode model actions, Cmd.none )

            StartGame ->
                ( actions.playingState, Cmd.none )


initialModel : Model
initialModel =
    { level = Level 5
    , state = Welcome
    , position = Position 2 2
    , enemies = [ Enemy (Position 0 0) 0.0  ]
    , gridElement = gridElement 5
    }

curryModel : Model -> Model
curryModel model =
    { model | gridElement = (gridElement model.level.size) }    


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

