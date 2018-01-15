module Updates.PlayerActions exposing (curryPlayerActions)

import Models.Models exposing (..)
import Models.Position exposing (..)

-- I thought I was currying these, but as there is only one parameter it looks like I am actually just callilng them and storing the result. That doesnt seem very clever.
curryPlayerActions : Model -> Actions
curryPlayerActions model =
    Actions (moveModelLeft model) (moveModelRight model) (moveModelUp model) (moveModelDown model) (moveModelTowards model)


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


moveModelTowards : Model -> Position -> Model
moveModelTowards model target =
    { model | position = movePositionTowards model.position target }

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

movePositionTowards : Position -> Position -> Position
movePositionTowards position targetPosition =
    Position (moveTowards position.x targetPosition.x) (moveTowards position.y targetPosition.y)

moveTowards : Int -> Int -> Int
moveTowards value targetValue =
    if (value > targetValue) then value + 1 else value - 1

