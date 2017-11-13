module Views.GameOver exposing (..)

import Models exposing (..)
import Html exposing (Html, text)
import Html.Attributes exposing (style)
import Html.Events

viewOver : Model -> Html Msg
viewOver model =
    Html.div
        [ style [ ( "max-width", "400px" ), ( "min-width", "280px" ), ( "flex", "1" ) ] ]
        [ Html.h1 [ style [ ( "font-size", "3em" ), ( "color", "#17e3b7" ) ] ]
            [ Html.text "Game Over" ]
        , Html.p []
            [ Html.text "Your score this time was:" ]
        , Html.h2 [ Html.Events.onClick StartGame ]
            [ Html.text "Restart" ]
        ]
