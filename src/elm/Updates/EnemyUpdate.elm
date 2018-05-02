module Updates.EnemyUpdate exposing (..)

import Models.Position exposing (..)
import Models.Enemy exposing (..)


-- we can't use a type alias within a type, I think this was the thing that was confusing me.
-- types don't have to be union types, they can just be a simple type
-- maybe make a pr to the repo with this.
type Position2 
    = Position2 Int Int

type OriginalAndDesiredPosition 
    = OriginalAndDesiredPosition Position2 Position2

type WithOriginalAndDesiredPosition a
    = WithOriginalAndDesiredPosition a OriginalAndDesiredPosition

type ValueAndContext valueType contextType
    = ValueAndContext valueType contextType

type alias EnemyUpdate3 a =
    { enemy : a
    , originalPosition : Position
    , desiredPosition : Position
    }

type alias EnemyUpdate =
    { enemy : Enemy
    , originalPosition : Position
    , desiredPosition : Position
    }


map : (Enemy -> Enemy) -> (EnemyUpdate -> EnemyUpdate)
map enemyFunction =
    (\enemyUpdate -> { enemyUpdate | enemy = enemyFunction enemyUpdate.enemy })


mapReturn : (EnemyUpdate -> Enemy) -> (EnemyUpdate -> EnemyUpdate)
mapReturn enemyFunction =
    (\enemyUpdate -> { enemyUpdate | enemy = enemyFunction enemyUpdate })



-- these -1s are bad, should use a maybe or something instead


initialEnemyUpdate : Enemy -> EnemyUpdate
initialEnemyUpdate enemy =
    EnemyUpdate enemy enemy.position (Position -1 -1)


enemy : EnemyUpdate -> Enemy
enemy enemyUpdate =
    enemyUpdate.enemy
