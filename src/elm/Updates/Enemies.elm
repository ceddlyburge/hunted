module Updates.Enemies exposing (updateEnemies, isOccupiedByEnemy)

import Updates.ValueAndContext exposing (..)
import Models.Models exposing (..)
import Models.Position exposing (..)
import Models.Enemy exposing (..)
import Queue exposing (..)

type alias EnemyUpdatePosition =
    { originalPosition : Position
    , desiredPosition : Position
    }

--type EnemyUpdate = ValueAndContext Enemy EnemyUpdatePosition


updateEnemies : Float -> Model -> Model
updateEnemies milliseconds model =
    { model | enemies = Queue.requeue (updateEnemy model milliseconds) model.enemies  }


isOccupiedByEnemy : Position -> Queue Enemy -> Bool
isOccupiedByEnemy position enemies =
    List.any (positionsEqual position) (Queue.toList enemies)


initialEnemyUpdate : Enemy -> (ValueAndContext Enemy EnemyUpdatePosition)
initialEnemyUpdate enemy =
    ValueAndContext enemy (EnemyUpdatePosition enemy.position (Position -1 -1))

-- we could have different types of enemies that update in different ways. This would probably be setup at the start of a level, with this function being added as a property to the Enemy type


updateEnemy : Model -> Float -> (Enemy -> Enemy)
updateEnemy model milliseconds =
    initialEnemyUpdate
        >> map (increaseEnemyEnergy milliseconds)
        >> setDesiredEnemyPosition model.position
        >> restoreContext (moveEnemyIfPossible model.enemies)
        >> resetEnergyIfMoved
        -->> restoreContext resetEnergyIfMoved
        -->> enemy


increaseEnemyEnergy : Float -> Enemy -> Enemy
increaseEnemyEnergy milliseconds enemy =
    { enemy | energy = enemy.energy + milliseconds }


setDesiredEnemyPosition : Position -> (ValueAndContext Enemy EnemyUpdatePosition) -> (ValueAndContext Enemy EnemyUpdatePosition)
setDesiredEnemyPosition playerPosition (ValueAndContext enemy enemyUpdatePosition) =
    ValueAndContext enemy {enemyUpdatePosition | desiredPosition = desiredEnemyPosition enemy.position playerPosition }

moveEnemyIfPossible : Queue Enemy -> (ValueAndContext Enemy EnemyUpdatePosition) -> Enemy
moveEnemyIfPossible enemies (ValueAndContext enemy enemyUpdatePosition) =
    if (canEnemyMove enemy enemyUpdatePosition.desiredPosition enemies) then
        setPosition enemy enemyUpdatePosition.desiredPosition
    else
        enemy


resetEnergyIfMoved : (ValueAndContext Enemy EnemyUpdatePosition) -> Enemy
resetEnergyIfMoved (ValueAndContext enemy enemyUpdatePosition) =
    if (enemy.position == enemyUpdatePosition.originalPosition) then
        enemy
    else
        resetEnergy enemy


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