module Util exposing (grid, gridElement)

import Svg exposing (svg, polygon, circle, rect)
import Svg.Attributes exposing (version, viewBox, points, fill, width, height, x, y)
import Models exposing (..)

addCoordToAll : Int -> List Int -> List Position
addCoordToAll n coords =
    List.map (\c -> { x = n, y = c }) coords


grid : Int -> Int -> List Position
grid n m =
    let
        coords =
            List.range 0 (m - 1)
    in
        List.map (\c -> addCoordToAll c coords) coords
            |> List.foldl (++) []

gridElement : Int -> String -> Position -> Svg.Svg msg
gridElement gridElementSize gridFill position  =
    rect 
    [ 
        x (toString (position.x * gridElementSize + 1)), 
        y (toString (position.y * gridElementSize + 1)), 
        width (toString (gridElementSize - 2)), 
        height (toString (gridElementSize - 2)),
        fill gridFill ] []

