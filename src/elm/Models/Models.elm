module Models.Models exposing (..)

import Models.Position exposing (..)
import Models.Enemy exposing (..)
import Queue exposing (..)
import Html exposing (Html, text)
import Time exposing (Time)
import Keyboard exposing (KeyCode)


type Msg
    = TimeUpdate Time
    | KeyDown KeyCode
    | StartGame
    | ShowWelcome


type State
    = Welcome
    | Playing
    | GameOver


type alias Level =
    { size : Int
    }


type alias Model =
    { level : Level
    , state : State
    , position : Position
    , playerTarget : Position 
    , enemies : Queue Enemy
    , grid : List Position
    , playerGridElement : Html Msg
    , backgroundGridElement : Position -> Html Msg
    , enemyGridElement : Enemy -> Html Msg
    }


type alias Actions =
    { moveLeft : Model
    , moveRight : Model
    , moveUp : Model
    , moveDown : Model
    }
