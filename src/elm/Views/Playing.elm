module Views.Playing exposing (playing)

import Models.Models exposing (..)
import Queue exposing (..)
import Html exposing (Html, text)
import Html.Attributes exposing (style)
import Svg exposing (svg, polygon, circle, rect)
import Svg.Attributes exposing (version, viewBox, points, fill, width, height, x, y)


playing : Model -> Html Msg
playing model =
    Html.div
        [ style [ ( "max-width", "400px" ), ( "min-width", "280px" ), ( "flex", "1" ) ] ]
        [ Html.h1 [ style [ ( "font-size", "0.5em" ), ( "display", "none" ) ] ]
            [ text (toString model) ]
        , svg [ version "1.1", viewBox "0 0 100 100" ]
            (   viewGridBackground model
                ++ [ model.playerGridElement ]
                ++ viewEnemies model
            )
        ]


viewGridBackground : Model -> List (Html Msg)
viewGridBackground model =
    List.map (model.backgroundGridElement) model.grid


viewEnemies : Model -> List (Html Msg)
viewEnemies model =
    List.map (model.enemyGridElement) (Queue.toList model.enemies)
