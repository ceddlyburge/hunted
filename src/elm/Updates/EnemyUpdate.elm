module Updates.EnemyUpdate exposing (..)

import Models.Position exposing (..)
import Models.Enemy exposing (..)


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
