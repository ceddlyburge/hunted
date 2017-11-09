module GameView exposing (..)

import Models exposing (..)
import Html exposing (Html, text)
import Html.Attributes exposing (style)
import Html.Events
import Svg exposing (svg, polygon, circle, rect)
import Svg.Attributes exposing (version, viewBox, points, fill, width, height, x, y)
import Util exposing (grid, gridElement)


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

            Over ->
                viewOver model
        ]


viewGame : Model -> Html Msg
viewGame model =
    let
        gridElemenSize =
            100 // model.level.size
    in
        Html.div
            [ style [ ( "max-width", "400px" ), ( "min-width", "280px" ), ( "flex", "1" ) ] ]
            [ Html.h1 [ style [ ( "font-size", "0.5em" ) ]]
                [ text (toString model) ]
            , svg [ version "1.1", viewBox "0 0 100 100" ]
                (viewGridBackground model gridElemenSize
                    ++ [ model.playerGridElement ]
                    ++ viewEnemies model gridElemenSize 
                )
            ]


viewGridBackground : Model -> Int -> List (Html Msg)
viewGridBackground model gridElementSize =
    List.map  (model.backgroundGridElement) (grid model.level.size model.level.size)


viewEnemies : Model -> Int -> List (Html Msg)
viewEnemies model gridElementSize =
    List.map (model.enemyGridElement) model.enemies

viewEnemy : Model -> Enemy -> Html Msg
viewEnemy model enemy =
    model.enemyGridElement enemy

viewStart : Model -> Html Msg
viewStart model =
    Html.div
        [ style [ ( "max-width", "400px" ), ( "min-width", "280px" ), ( "flex", "1" ) ] ]
        [ Html.h1 [ style [ ( "font-size", "3em" ), ( "color", "#E31743" ) ] ]
            [ Html.text "Hunted" ]
        , Html.p []
            [ Html.text "Pacman/Snake/... ish game" ]
        , Html.p []
            [ Html.text "Use the arrow keys to move." ]
        , Html.h2 [ Html.Events.onClick StartGame ]
            [ Html.text "Start" ]
        ]


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
