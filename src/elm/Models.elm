module Models exposing (..)


type State
    = Welcome
    | Playing
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

type alias Actions =
    { moveLeft : Model
    , moveRight : Model
    , moveUp : Model
    , moveDown : Model
    , welcomeState : Model
    , playingState : Model
    }
