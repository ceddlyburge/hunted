module Updates exposing (..)

import Models exposing (..)
import Time exposing (Time)
import Keyboard exposing (KeyCode)


type Msg
    = TimeUpdate Time
    | KeyDown KeyCode
    | StartGame

curryModel : Model -> CurriedModel
curryModel model =
    CurriedModel model (moveModelLeft model) (moveModelRight model) (moveModelUp model) (moveModelDown model) (start model)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let 
        curriedModel = curryModel model
    in
        case msg of
            TimeUpdate dt ->
                ( model, Cmd.none )

            KeyDown keyCode ->
                ( keyDown keyCode curriedModel, Cmd.none )

            StartGame ->
                ( { model | state = Game }, Cmd.none )


initialModel : Model
initialModel =
    { level = Level 5
    , state = Start
    , position = Position 2 2
    , enemies = [ Enemy (Position 0 0) 0.0  ]
    }

start : Model -> Model
start model =
    { model | state = Start }

moveModelUp : Model -> Model
moveModelUp model =
        { model | position = (moveUp model.position) }

moveModelDown : Model -> Model
moveModelDown model =
        { model | position = (moveDown model.position) }

moveModelLeft : Model -> Model
moveModelLeft model =
        { model | position = (moveLeft model.position) }

moveModelRight : Model -> Model
moveModelRight model =
        { model | position = (moveRight model.position) }

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

keyDown : KeyCode -> CurriedModel -> Model
keyDown keyCode model =
    case keyCode of
        37 ->
                model.moveLeft 
        39 ->
                model.moveRight
        38 ->
                model.moveUp 
        40 ->
                model.moveDown 
        27 ->
                model.start 
        _ ->
                model.model
