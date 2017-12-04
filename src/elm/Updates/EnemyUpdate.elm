module Updates.EnemyUpdate exposing (..)

import Models.Position exposing (..)
import Models.Enemy exposing (..)

import Updates.Context exposing (..)

type alias EnemyUpdate =
    { enemy : Enemy
    , originalPosition : Position
    , desiredPosition : Position
    }

-- functors (fmap) take a function that takes a value and returns a value, returning a function that both takes and returns a value + context
-- monads  (liftM) take a function that takes a value and returns a value + context, returning a function that both takes and return a value + context
-- applicatives (liftA) take a function + context, where the function takes a value and returns a value, returning a function that returns value + context
-- no definition for something that takes a function that takes a value + context and returns a value, functions basically shouldn't take a context it seems

-- (functor) work with a function that takes an enemy and returns an enemy (increaseEnergyFromTime)
map : (Enemy -> Enemy) -> (EnemyUpdate -> EnemyUpdate)
map enemyFunction =
    (\enemyUpdate -> { enemyUpdate | enemy = enemyFunction enemyUpdate.enemy })

-- (monad) work with a function that takes an enemy and returns an enemyUpdate (desiredPosition)

-- (no defintion) work with a function that takes an enemyUpdate and returns an enemy (decreaseEnergyFromMovement)
mapReturn : (EnemyUpdate -> Enemy) -> (EnemyUpdate -> EnemyUpdate)
mapReturn enemyFunction =
    (\enemyUpdate -> { enemyUpdate | enemy = enemyFunction enemyUpdate })

initialEnemyUpdate : Enemy -> EnemyUpdate
initialEnemyUpdate enemy =
    EnemyUpdate enemy enemy.position (Position -1 -1) -- these -1s are bad, should use a maybe or something instead

enemy : EnemyUpdate -> Enemy
enemy  enemyUpdate =
    enemyUpdate.enemy
