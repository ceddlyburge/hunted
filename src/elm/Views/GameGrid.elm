module Views.GameGrid exposing (curryModel)

import Html exposing (Html, text)
import Svg exposing (svg, polygon, circle, rect)
import Svg.Attributes exposing (version, viewBox, points, fill, width, height, x, y)
import Models.Models exposing (..)
import Models.Position exposing (..)
import Models.Enemy exposing (..)

curryModel : Model -> Model
curryModel model =
    let
        gridElemenSize =
            100 // model.level.size  
    in
            { model | 
            grid = (grid model.level.size model.level.size)
            , backgroundGridElement = (gridElement gridElemenSize "#000000" ) 
            , playerGridElement = (gridElement gridElemenSize "#d9d9d9" model.position) 
            , enemyGridElement = (enemyGridElement gridElemenSize "#ff6666") 
        }    

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

gridElement : Int -> String -> Position -> Html Msg
gridElement gridElementSize gridFill position  =
    rect 
    [ 
        x (toString (position.x * gridElementSize + 1)), 
        y (toString (position.y * gridElementSize + 1)), 
        width (toString (gridElementSize - 2)), 
        height (toString (gridElementSize - 2)),
        fill gridFill ] []

enemyGridElement : Int -> String -> (Enemy -> Html Msg)
enemyGridElement gridElementSize gridFill = 
    (\enemy -> gridElement gridElementSize gridFill enemy.position)
