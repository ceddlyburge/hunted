module Updates.Context exposing (..)

type Context value context =
    Context value context


-- functors (fmap) take a function that takes a value and returns a value, returning a function that both takes and returns a value + context
-- monads  (liftM) take a function that takes a value and returns a value + context, returning a function that both takes and return a value + context
-- applicatives (liftA) take a function + context, where the function takes a value and returns a value, returning a function that returns value + context
-- no definition for something that takes a function that takes a value + context and returns a value, functions basically shouldn't take a context it seems

-- (functor) work with a function that takes a value and returns a value
fmap : (value -> value) -> (Context value context -> Context value context)
fmap valueToValueFunction =
    wrapFunctionInContext valueToValueFunction
    -- (\context -> 
    --     case context of
    --         Context value context ->
    --             Context (valueFunction value) context )

wrapFunctionInContext : (value -> value) -> Context value context -> Context value context
wrapFunctionInContext valueFunction context =
        case context of
            Context value context ->
                Context (valueFunction value) context

-- (monad) work with a function that takes a value and returns a value and context
-- this throws away any existing context and replaces it with that returned by the function
liftM : (value -> Context value context) -> (Context value context -> Context value context)
liftM valueToContextFunction =
    wrapFunctionInputInContext valueToContextFunction
    -- (\context2 -> 
    --     case context2 of
    --         Context value context ->
    --             valueToContextFunction value )

wrapFunctionInputInContext : (value -> Context value context) -> Context value context -> Context value context
wrapFunctionInputInContext valueToContextFunction context =
    case context of
        Context value context ->
            valueToContextFunction value

-- applicatives (liftA) take a function + context, where the function takes a value and returns a value, returning a function that returns value + context

-- (no defintion that I know of) work with a function that takes a value and context and returns a value
-- mapf : (Context value context -> value) -> (Context value context -> Context value context)
-- mapf contextToValueFunction =
--     (\context2 -> 
--         case context2 of
--             Context value context ->
--                 valueToContextFunction value )
