module Updates.Context exposing (..)

type ValueAndContext value context =
    ValueAndContext value context


-- functors (fmap) take a function that takes a value and returns a value, returning a function that both takes and returns a value + context
-- monads  (liftM) take a function that takes a value and returns a value + context, returning a function that both takes and return a value + context
-- applicatives (liftA) take a function + context, where the function takes a value and returns a value, returning a function that returns value + context
-- no definition for something that takes a function that takes a value + context and returns a value, functions basically shouldn't take a context it seems

-- (functor) work with a function that takes a value and returns a value
map : (value -> value) -> (ValueAndContext value context -> ValueAndContext value context)
map valueToValueFunction =
    wrapFunctionInContext valueToValueFunction

wrapFunctionInContext : (value -> value) -> ValueAndContext value context -> ValueAndContext value context
wrapFunctionInContext valueFunction context =
        case context of
            ValueAndContext value context ->
                ValueAndContext (valueFunction value) context

-- (monad) work with a function that takes a value and returns a value and context
liftM : (value -> ValueAndContext value context) -> (ValueAndContext value context -> ValueAndContext value context)
liftM valueToContextFunction =
    wrapFunctionInputInContextAndDiscardExistingContext valueToContextFunction

wrapFunctionInputInContextAndDiscardExistingContext : (value -> ValueAndContext value context) -> ValueAndContext value context -> ValueAndContext value context
wrapFunctionInputInContextAndDiscardExistingContext valueToContextFunction context =
    case context of
        ValueAndContext value context ->
            valueToContextFunction value

-- applicatives (liftA) work with a (function + context) and a (value + contect), where the function takes a value and returns a value, returning a value + context
-- function  context is discarded. This type doesn't seem to make a very useful applicative.
liftA : ValueAndContext (value -> value) context -> (ValueAndContext value context -> ValueAndContext value context)
liftA valueFunctionAndContext =
    case valueFunctionAndContext of
        ValueAndContext valueFunction contextToDiscard ->
            (\context2 -> 
                case context2 of
                    ValueAndContext value context ->
                        ValueAndContext (valueFunction value) context )

-- (no defintion that I know of) work with a function that takes a value and context and returns a value
-- called it mapf to indicate it is kind of the opposite of fmap
mapReturn : (ValueAndContext value context -> value) -> (ValueAndContext value context -> ValueAndContext value context)
mapReturn contextToValueFunction =
    wrapFunctionOutputInContext contextToValueFunction
    -- (\context2 -> 
    --     case context2 of
    --         Context value context ->
    --             Context (contextToValueFunction context2) context )

wrapFunctionOutputInContext : (ValueAndContext value context -> value) -> ValueAndContext value context -> ValueAndContext value context
wrapFunctionOutputInContext contextToValueFunction context =
    case context of
        ValueAndContext value context2 ->
            ValueAndContext (contextToValueFunction context) context2