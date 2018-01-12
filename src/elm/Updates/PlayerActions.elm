module Updates.PlayerActions exposing (curryPlayerActions)

import Models.Models exposing (..)
import Models.Position exposing (..)


curryPlayerActions : Model -> Actions
curryPlayerActions model =
    Actions (moveModelLeft model) (moveModelRight model) (moveModelUp model) (moveModelDown model)


setTarget : Model -> Position -> Model
setTarget model newTarget =
    { model | playerTarget = newTarget }


moveModelUp : Model -> Model
moveModelUp model =
    { model | position = (moveUp model.position) }


moveModelDown : Model -> Model
moveModelDown model =
    { model | position = (moveDown model.position (model.level.size - 1)) }


moveModelLeft : Model -> Model
moveModelLeft model =
    { model | position = (moveLeft model.position) }


moveModelRight : Model -> Model
moveModelRight model =
    { model | position = (moveRight model.position (model.level.size - 1)) }


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
