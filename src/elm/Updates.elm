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
    , enemies = [ Enemy (Position 0 0) 0.0  ]
    }

moveUp : Position -> Position
moveUp position =
        { position | y = max 0 (position.y - 1) }

moveDown : Position -> Position
moveDown position =
        { position | y = min 4 (position.y + 1) }

moveLeft : Position -> Position
moveLeft position =
        { position | x = max 0 (position.x - 1) }

moveRight : Position -> Position
moveRight position =
        { position | x = min 4 (position.x + 1) }

keyDown : KeyCode -> Model -> Model
keyDown keyCode model =
    case keyCode of
        38 ->
                { model | position = (moveUp model.position) }
        40 ->
                { model | position = (moveDown model.position) }
        37 ->
                { model | position = (moveLeft model.position) }
        39 ->
                { model | position = (moveRight model.position) }
        27 ->
            { model | state = Start }
        _ ->
             model
