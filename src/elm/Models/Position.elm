module Models.Position exposing (..)


type alias Position =
    { x : Int
    , y : Int
    }


equals : Position -> Position -> Bool
equals position1 position2 =
    position1.x == position2.x && position1.y == position2.y
