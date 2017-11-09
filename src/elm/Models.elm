module Models exposing (..)

import Html exposing (Html, text)
import Time exposing (Time)
import Keyboard exposing (KeyCode)

type Msg
    = TimeUpdate Time
    | KeyDown KeyCode
    | StartGame

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
    , gridElement : String -> Position -> Html Msg
    , playerGridElement : Html Msg
    , backgroundGridElement : Position -> Html Msg
    , enemyGridElement : Enemy -> Html Msg
    }

type alias Views =
    { moveLeft : Model
    }

type alias Actions =
    { moveLeft : Model
    , moveRight : Model
    , moveUp : Model
    , moveDown : Model
    , welcomeState : Model
    , playingState : Model
    }
