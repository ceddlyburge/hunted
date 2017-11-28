module Models.Enemy exposing (..)

import Models.Position exposing (..)

type alias Enemy =
    { position : Position
    , energy : Float
    }

positionsEqual : Position -> Enemy -> Bool
positionsEqual position enemy =
    Models.Position.equals position enemy.position

setPosition : Enemy -> Position -> Enemy 
setPosition enemy newPosition =
        { enemy | position = newPosition }

resetEnergy : Enemy -> Enemy
resetEnergy  enemy =
    { enemy | energy = 0 }
