module Models.Enemy exposing (..)

import Models.Position exposing (..)

type alias Enemy =
    { position : Position
    , energy : Float
    }

enemyPositionEqual : Position -> Enemy -> Bool
enemyPositionEqual position enemy =
    positionsEqual position enemy.position

moveEnemy : Enemy -> Position -> Enemy 
moveEnemy enemy newPosition =
        { enemy | position = newPosition }

resetEnergy : Enemy -> Enemy
resetEnergy  enemy =
    { enemy | energy = 0 }
