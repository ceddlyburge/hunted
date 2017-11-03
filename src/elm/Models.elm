module Models exposing (..)


type State
    = Game
    | Start
    | Over

type alias Level =
    { size : Int
    }

type alias Position = 
    { x: Int
    , y : Int }

type alias Enemy =
    { x : Int
    , y : Int
    , energy : Float
    }


type alias Model =
    { level : Level
    , state : State
    , x : Int
    , y : Int
    , enemies : List Enemy
    }
