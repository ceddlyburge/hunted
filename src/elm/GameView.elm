module GameView exposing (..)

import Views.Start exposing (..)
import Views.GameOver exposing (..)
import Views.Playing exposing (..)
import Models exposing (..)
import Html exposing (Html, text)
import Html.Attributes exposing (style)


view : Model -> Html Msg
view model =
    Html.div
        [ style
            [ ( "width", "100%" )
            , ( "height", "100%" )
            , ( "background", "#1f1f1f" )
            , ( "color", "white" )
            , ( "display", "flex" )
            , ( "align-items", "center" )
            , ( "justify-content", "center" )
            , ( "font-family", "Futura" )
            , ( "text-align", "center" )
            ]
        ]
        [ case model.state of
            Welcome ->
                viewStart model

            Playing ->
                viewGame model

            GameOver ->
                viewOver model
        ]

