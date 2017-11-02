module Updates exposing (..)

import Models exposing (..)
import Time exposing (Time)
import Keyboard exposing (KeyCode)


type Msg
    = TimeUpdate Time
    | KeyDown KeyCode
    | StartGame


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TimeUpdate dt ->
            ( model, Cmd.none )

        KeyDown keyCode ->
            ( keyDown keyCode model, Cmd.none )

        StartGame ->
            ( { model | state = Game }, Cmd.none )


initialModel : Model
initialModel =
    { level = Level 5
    , state = Start
    , x = 2
    , y = 2
    , enemies = [ Enemy 0 0 0.0 ]
    }


keyDown : KeyCode -> Model -> Model
keyDown keyCode model =
    case keyCode of
        38 ->
            if model.y > 0 then
                { model | y = model.y - 1 }
            else
                model

        40 ->
            if model.y < 4 then
                { model | y = model.y + 1 }
            else
                model

        37 ->
            if model.x > 0 then
                { model | x = model.x - 1 }
            else
                model

        39 ->
            if model.x < 4 then
                { model | x = model.x + 1 }
            else
                model

        27 ->
            { model
                | state = Start
            }

        _ ->
            model
