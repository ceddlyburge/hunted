module Updates.EnemyUpdate exposing (..)

import Models.Models exposing (..)

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
fmap : (Enemy -> Enemy) -> (EnemyUpdate -> EnemyUpdate)
fmap enemyFunction =
    (\enemyUpdate -> { enemyUpdate | enemy = enemyFunction enemyUpdate.enemy })

-- (monad) work with a function that takes an enemy and returns an enemyUpdate (desiredPosition)

-- (no defintion) work with a function that takes an enemyUpdate and returns an enemy (decreaseEnergyFromMovement)
mapf : (EnemyUpdate -> Enemy) -> (EnemyUpdate -> EnemyUpdate)
mapf enemyFunction =
    (\enemyUpdate -> { enemyUpdate | enemy = enemyFunction enemyUpdate })


enemy : EnemyUpdate -> Enemy
enemy  enemyUpdate =
    enemyUpdate.enemy
