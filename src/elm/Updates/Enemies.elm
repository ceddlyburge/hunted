module Updates.Enemies exposing (updateEnemies, isOccupiedByEnemy)

import Updates.EnemyUpdate exposing (..)
import Models.Models exposing (..)
import Queue exposing (..)

-- level 1
updateEnemies :  Float -> Model -> Model
updateEnemies milliseconds model = 
    { model | enemies = processTopOfQueueAndReturnToQueue model.enemies (updateEnemy model milliseconds) }

-- level 2

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

updateEnemy : Model -> Float -> (Enemy -> Enemy)
updateEnemy model milliseconds =
    initialEnemyUpdate
    >> fmap (increaseEnemyEnergy milliseconds)
    >> setDesiredEnemyPosition model.position
    >> mapf (moveEnemyIfPossible model.enemies)
    >> mapf resetEnergyIfMoved
    >> enemy

-- level 3

initialEnemyUpdate : Enemy -> EnemyUpdate
initialEnemyUpdate enemy =
    EnemyUpdate enemy enemy.position (Position -1 -1) -- these -1s are bad, should use a maybe instead

increaseEnemyEnergy : Float -> Enemy -> Enemy
increaseEnemyEnergy milliseconds enemy =
    { enemy | energy = enemy.energy + milliseconds }

setDesiredEnemyPosition : Position -> EnemyUpdate -> EnemyUpdate
setDesiredEnemyPosition playerPosition enemyUpdate =
    { enemyUpdate | desiredPosition = desiredEnemyPosition enemyUpdate.enemy.position playerPosition}

moveEnemyIfPossible : Queue Enemy -> EnemyUpdate -> Enemy
moveEnemyIfPossible enemies enemyUpdate =
    if (canEnemyMove enemyUpdate.enemy enemyUpdate.desiredPosition enemies ) then
        moveEnemy enemyUpdate.enemy enemyUpdate.desiredPosition 
    else
        enemyUpdate.enemy

resetEnergyIfMoved : EnemyUpdate -> Enemy
resetEnergyIfMoved  enemyUpdate =
   if (enemyUpdate.enemy.position == enemyUpdate.originalPosition) then
       enemyUpdate.enemy
   else
       resetEnergy enemyUpdate.enemy

-- level 4
desiredEnemyPosition : Position -> Position -> Position
desiredEnemyPosition enemyPosition playerPosition =
    Position 
        (moveTowards enemyPosition.x playerPosition.x)
        (moveTowards enemyPosition.y playerPosition.y)

canEnemyMove : Enemy -> Position -> Queue Enemy -> Bool
canEnemyMove enemy desiredPosition enemies =
    (enemy.energy >= 2) && (isOccupiedByEnemy desiredPosition enemies == False)

moveEnemy : Enemy -> Position -> Enemy 
moveEnemy enemy newPosition =
        { enemy | position = newPosition }

resetEnergy : Enemy -> Enemy
resetEnergy  enemy =
    { enemy | energy = 0 }

--level 3

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

-- updateEnemyPositionAndEnergy : Queue Enemy -> Position -> Enemy -> Enemy
-- updateEnemyPositionAndEnergy  enemies playerPosition enemy =
--     let 
--         newPosition = desiredEnemyPosition enemy.position playerPosition
--     in
--         if (canEnemyMove enemy newPosition enemies ) then
--             { enemy |
--                 position = newPosition 
--                 , energy = 0 }
--         else
--             enemy

-- updateEnemy : Model -> Float -> (Enemy -> Enemy)
-- updateEnemy model milliseconds =
--     increaseEnemyEnergy milliseconds
--     >> updateEnemyPositionAndEnergy model.enemies model.position
