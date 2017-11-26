module Updates.Enemies exposing (updateEnemies, isOccupiedByEnemy)

import Models.Models exposing (..)
import Queue exposing (..)

type alias EnemyUpdate =
    { enemy : Enemy
    , originalPosition : Position
    , desiredPosition : Position
    , newPosition : Position
    }

-- work with a function that takes an enemy and returns an enemy (increaseEnergyFromTime)
fmap : (Enemy -> Enemy) -> (EnemyUpdate -> EnemyUpdate)
fmap enemyFunction =
    (\enemyUpdate -> {enemyUpdate | enemy = enemyFunction enemyUpdate.enemy })


-- work with a function that takes an enemy and returns an enemyUpdate (desiredPosition)

-- work with a function that takes an enemyUpdate and returns an enemy (decreaseEnergyFromMovement)

-- increase energy (milliseconds)
-- get desired position (current position, player position, probably energy)
-- set new position (desired position, list of enemies)
-- decrease energy (originalPosition, newposition)

updateEnemy2 : Model -> Float -> (EnemyUpdate -> EnemyUpdate)
updateEnemy2 model milliseconds =
    fmap (increaseEnemyEnergy milliseconds)
    >> desiredEnemyPosition2 model.position
    >> newEnemyPosition model.enemies
    -->> updateEnemyPositionAndEnergy model.enemies model.position

desiredEnemyPosition2 : Position -> EnemyUpdate -> EnemyUpdate
desiredEnemyPosition2 playerPosition enemyUpdate =
    { enemyUpdate | desiredPosition = desiredEnemyPosition enemyUpdate.enemy.position playerPosition}

newEnemyPosition : Queue Enemy -> EnemyUpdate -> EnemyUpdate
newEnemyPosition  enemies enemyUpdate =
    if (canEnemyMove enemyUpdate.enemy enemyUpdate.desiredPosition enemies ) then
        { enemyUpdate | newPosition = enemyUpdate.desiredPosition }
    else
        enemyUpdate


processTopOfQueueAndReturnToQueue : Queue a -> (a -> a) -> Queue a
processTopOfQueueAndReturnToQueue queue processor =
    let
      (maybeItem, list) = Queue.deq queue
    in
      case maybeItem of
        Just item ->
            Queue.enq (processor item) list 
        Nothing ->
            list

updateEnemies :  Float -> Model -> Model
updateEnemies milliseconds model = 
    { model | enemies = processTopOfQueueAndReturnToQueue model.enemies (updateEnemy model milliseconds) }

updateEnemy : Model -> Float -> (Enemy -> Enemy)
updateEnemy model milliseconds =
    increaseEnemyEnergy milliseconds
    >> updateEnemyPositionAndEnergy model.enemies model.position

increaseEnemyEnergy : Float -> Enemy -> Enemy
increaseEnemyEnergy milliseconds enemy =
    { enemy | energy = enemy.energy + milliseconds }

updateEnemyPositionAndEnergy : Queue Enemy -> Position -> Enemy -> Enemy
updateEnemyPositionAndEnergy  enemies playerPosition enemy =
    let 
        newPosition = desiredEnemyPosition enemy.position playerPosition
    in
        if (canEnemyMove enemy newPosition enemies ) then
            { enemy |
                position = newPosition 
                , energy = 0 }
        else
            enemy

canEnemyMove : Enemy -> Position -> Queue Enemy -> Bool
canEnemyMove enemy desiredPosition enemies =
    (enemy.energy >= 2) && (isOccupiedByEnemy desiredPosition enemies == False)

desiredEnemyPosition : Position -> Position -> Position
desiredEnemyPosition enemyPosition playerPosition =
    Position 
        (moveTowards enemyPosition.x playerPosition.x)
        (moveTowards enemyPosition.y playerPosition.y)

moveTowards : Int -> Int -> Int
moveTowards current target =
    if current > target then
        current - 1
    else if current < target then
        current + 1
    else
        current

isOccupiedByEnemy : Position -> Queue Enemy -> Bool
isOccupiedByEnemy position enemies =
    List.any (enemyPositionEqual position) (Queue.toList enemies)

enemyPositionEqual : Position -> Enemy -> Bool
enemyPositionEqual position enemy =
    positionsEqual position enemy.position

positionsEqual : Position -> Position -> Bool
positionsEqual position1 position2 =
    position1.x == position2.x && position1.y == position2.y
