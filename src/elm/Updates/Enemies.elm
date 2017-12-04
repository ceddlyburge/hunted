module Updates.Enemies exposing (updateEnemies, isOccupiedByEnemy)

import Updates.EnemyUpdate exposing (..)
import Models.Models exposing (..)
import Models.Position exposing (..)
import Models.Enemy exposing (..)
import Queue exposing (..)


updateEnemies : Float -> Model -> Model
updateEnemies milliseconds model =
    { model | enemies = processTopOfQueueAndReturnToQueue model.enemies (updateEnemy model milliseconds) }



-- this should be added as a method in the queue module


processTopOfQueueAndReturnToQueue : Queue a -> (a -> a) -> Queue a
processTopOfQueueAndReturnToQueue queue processor =
    let
        ( maybeItem, list ) =
            Queue.deq queue
    in
        case maybeItem of
            Just item ->
                Queue.enq (processor item) list

            Nothing ->
                list



-- we could have different types of enemies that update in different ways. This would probably be setup at the start of a level, with this function being added as a property to the Enemy type


updateEnemy : Model -> Float -> (Enemy -> Enemy)
updateEnemy model milliseconds =
    initialEnemyUpdate
        >> map (increaseEnemyEnergy milliseconds)
        >> setDesiredEnemyPosition model.position
        >> mapReturn (moveEnemyIfPossible model.enemies)
        >> mapReturn resetEnergyIfMoved
        >> enemy


increaseEnemyEnergy : Float -> Enemy -> Enemy
increaseEnemyEnergy milliseconds enemy =
    { enemy | energy = enemy.energy + milliseconds }


setDesiredEnemyPosition : Position -> EnemyUpdate -> EnemyUpdate
setDesiredEnemyPosition playerPosition enemyUpdate =
    { enemyUpdate | desiredPosition = desiredEnemyPosition enemyUpdate.enemy.position playerPosition }


moveEnemyIfPossible : Queue Enemy -> EnemyUpdate -> Enemy
moveEnemyIfPossible enemies enemyUpdate =
    if (canEnemyMove enemyUpdate.enemy enemyUpdate.desiredPosition enemies) then
        setPosition enemyUpdate.enemy enemyUpdate.desiredPosition
    else
        enemyUpdate.enemy


resetEnergyIfMoved : EnemyUpdate -> Enemy
resetEnergyIfMoved enemyUpdate =
    if (enemyUpdate.enemy.position == enemyUpdate.originalPosition) then
        enemyUpdate.enemy
    else
        resetEnergy enemyUpdate.enemy


desiredEnemyPosition : Position -> Position -> Position
desiredEnemyPosition enemyPosition playerPosition =
    Position
        (moveTowards enemyPosition.x playerPosition.x)
        (moveTowards enemyPosition.y playerPosition.y)


canEnemyMove : Enemy -> Position -> Queue Enemy -> Bool
canEnemyMove enemy desiredPosition enemies =
    (enemy.energy >= 2) && (isOccupiedByEnemy desiredPosition enemies == False)


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
    List.any (positionsEqual position) (Queue.toList enemies)
