module CurryActions exposing (curryActions)

import Models exposing (..)

curryActions : Model -> Actions
curryActions model =
    Actions (moveModelLeft model) (moveModelRight model) (moveModelUp model) (moveModelDown model) (welcomeState model) (playingState model)

welcomeState : Model -> Model
welcomeState model =
    { model | state = Welcome }

playingState : Model -> Model
playingState model =
    { model | state = Playing }

moveModelUp : Model -> Model
moveModelUp model =
        { model | position = (moveUp model.position) }

moveModelDown : Model -> Model
moveModelDown model =
        { model | position = (moveDown model.position model.level.size) }

moveModelLeft : Model -> Model
moveModelLeft model =
        { model | position = (moveLeft model.position) }

moveModelRight : Model -> Model
moveModelRight model =
        { model | position = (moveRight model.position model.level.size) }

moveUp : Position -> Position
moveUp position =
        { position | y = max 0 (position.y - 1) }

moveDown : Position -> Int -> Position
moveDown position extent =
        { position | y = min extent (position.y + 1) }

moveLeft : Position -> Position
moveLeft position =
        { position | x = max 0 (position.x - 1) }

moveRight : Position -> Int -> Position
moveRight position extent =
        { position | x = min extent (position.x + 1) }
