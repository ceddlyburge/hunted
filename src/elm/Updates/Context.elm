module Updates.Context exposing (..)

type Context a b =
    ValueAndContext a b


-- functors (fmap) take a function that takes a value and returns a value, returning a function that both takes and returns a value + context
-- monads  (liftM) take a function that takes a value and returns a value + context, returning a function that both takes and return a value + context
-- applicatives (liftA) take a function + context, where the function takes a value and returns a value, returning a function that returns value + context
-- no definition for something that takes a function that takes a value + context and returns a value, functions basically shouldn't take a context it seems

-- (functor) work with a function that takes a value and returns a value
fmap : (a -> a) -> (Context a b -> Context a b)
fmap valueFunction =
    (\context -> 
        case context of
            ValueAndContext a b ->
                ValueAndContext (valueFunction a) b )

-- (monad) work with a function that takes an enemy and returns an enemyUpdate (desiredPosition)

-- (no defintion) work with a function that takes an enemyUpdate and returns an enemy (decreaseEnergyFromMovement)
