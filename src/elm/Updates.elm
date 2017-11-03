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
    , position = Position 2 2
    , enemies = [ Enemy 0 0 0.0 ]
    }

keyDown : KeyCode -> Model -> Model
keyDown keyCode model =
    case keyCode of
        38 ->
            if model.position.y > 0 then
                { model | position = Position model.position.x (model.position.y - 1) }
            else
                model
        40 ->
            if model.position.y < 4 then
                { model | position = Position model.position.x (model.position.y + 1) }
            else
                model

        37 ->
            if model.position.x > 0 then
                { model | position = Position (model.position.x - 1)  model.position.y }
            else
                model

        39 ->
            if model.position.x < 4 then
                { model | position = Position (model.position.x + 1)  model.position.y }
            else
                model

        27 ->
            { model
                | state = Start
            }

        _ ->
             model


-- keyDown : KeyCode -> Model -> Model
-- keyDown keyCode model =
--     case keyCode of
--         38 ->
--             if model.position.y > 0 then
--                 { model | y = model.y - 1 }
--             else
--                 model

--         40 ->
--             if model.y < 4 then
--                 { model | y = model.y + 1 }
--             else
--                 model

--         37 ->
--             if model.x > 0 then
--                 { model | x = model.x - 1 }
--             else
--                 model

--         39 ->
--             if model.x < 4 then
--                 { model | x = model.x + 1 }
--             else
--                 model

--         27 ->
--             { model
--                 | state = Start
--             }

--         _ ->
--             model
