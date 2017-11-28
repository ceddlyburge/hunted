module Models.Position exposing (..)
type alias Position = 
    { x: Int
    , y : Int }

positionsEqual : Position -> Position -> Bool
positionsEqual position1 position2 =
    position1.x == position2.x && position1.y == position2.y

