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
    { position : Position
    , energy : Float
    }


type alias Model =
    { level : Level
    , state : State
    , position : Position
    , enemies : List Enemy
    }

type alias CurriedModel =
    { model : Model
    , moveLeft : Model
    , moveRight : Model
    , moveUp : Model
    , moveDown : Model
    , start : Model
    }
