module Util exposing (grid, grid2, gridElement, gridElement2)

import Svg exposing (svg, polygon, circle, rect)
import Svg.Attributes exposing (version, viewBox, points, fill, width, height, x, y)
import Models exposing (..)


addCoordToAll : Int -> List Int -> List ( Int, Int )
addCoordToAll n coords =
    List.map (\c -> ( n, c )) coords


grid : Int -> Int -> List (Int, Int)
grid n m =
    let
        coords =
            List.range 0 (m - 1)
    in
        List.map (\c -> addCoordToAll c coords) coords
            |> List.foldl (++) []

addCoordToAll2 : Int -> List Int -> List Position
addCoordToAll2 n coords =
    List.map (\c -> { x = n, y = c }) coords


grid2 : Int -> Int -> List Position
grid2 n m =
    let
        coords =
            List.range 0 (m - 1)
    in
        List.map (\c -> addCoordToAll2 c coords) coords
            |> List.foldl (++) []

gridElement : Int -> String -> Int -> Int -> Svg.Svg msg
gridElement gridElementSize gridFill gridX gridY  =
    rect 
    [ 
        x (toString (gridX * gridElementSize + 1)), 
        y (toString (gridY * gridElementSize + 1)), 
        width (toString (gridElementSize - 2)), 
        height (toString (gridElementSize - 2)),
        fill gridFill ] []

gridElement2 : Int -> String -> Position -> Svg.Svg msg
gridElement2 gridElementSize gridFill position  =
    rect 
    [ 
        x (toString (position.x * gridElementSize + 1)), 
        y (toString (position.y * gridElementSize + 1)), 
        width (toString (gridElementSize - 2)), 
        height (toString (gridElementSize - 2)),
        fill gridFill ] []

