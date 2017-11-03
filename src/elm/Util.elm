module Util exposing (grid, gridElement)

import Html exposing (Html, text)
import Html.Attributes exposing (style)
import Html.Events
import Svg exposing (svg, polygon, circle, rect)
import Svg.Attributes exposing (version, viewBox, points, fill, width, height, x, y)


addCoordToAll : Int -> List Int -> List ( Int, Int )
addCoordToAll n coords =
    List.map (\c -> ( n, c )) coords


grid : Int -> Int -> List ( Int, Int )
grid n m =
    let
        coords =
            List.range 0 (m - 1)
    in
        List.map (\c -> addCoordToAll c coords) coords
            |> List.foldl (++) []

gridElement : Int ->  Int -> Int -> String -> Svg.Svg msg
gridElement gridX gridY gridElementSize gridFill =
    rect 
    [ 
        x (toString (gridX * gridElementSize + 1)), 
        y (toString (gridY * gridElementSize + 1)), 
        width (toString (gridElementSize - 2)), 
        height (toString (gridElementSize - 2)),
        fill gridFill ] []

