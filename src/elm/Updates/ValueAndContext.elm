module Updates.ValueAndContext exposing (..)
-- we can't use a type alias within a type, I think this was the thing that was confusing me.
-- types don't have to be union types, they can just be a simple type
-- maybe make a pr to the elm repo with this.
-- type Position2 
--     = Position2 Int Int

-- type OriginalAndDesiredPosition 
--     = OriginalAndDesiredPosition Position2 Position2

-- type WithOriginalAndDesiredPosition a
--     = WithOriginalAndDesiredPosition a OriginalAndDesiredPosition

type ValueAndContext valueType contextType
    = ValueAndContext valueType contextType

map : (a -> a) -> (ValueAndContext a b -> ValueAndContext a b)
map functionToMap =
    (\(ValueAndContext value context) -> ValueAndContext (functionToMap value) context)





-- -- I found writing this class a useful exercise, but actually it isn't very useful, mainly because its too difficult to use.
-- -- The problem is that its a union type (but with only one type in the union). However we still need to use a case statement to get access to the single unioned type, which is annoying.
-- -- The other way of writing this module is done with a type alias (in EnemyUpdate), which is a lot easier to use. The disadvantage of this is that it is not generic, so you have to rewrite the class if you want to use it with different types.
-- -- It feels like there should be a way of doing this in a convenient and generic way, but as far as I am aware there is not.


-- module Updates.Context exposing (..)


-- type ValueAndContext value context
--     = ValueAndContext value context



-- -- functors (fmap) take a function that takes a value and returns a value, returning a function that both takes and returns a value + context
-- -- monads  (liftM) take a function that takes a value and returns a value + context, returning a function that both takes and return a value + context
-- -- applicatives (liftA) take a function + context, where the function takes a value and returns a value, returning a function that returns value + context
-- -- no definition for something that takes a function that takes a value + context and returns a value, functions basically shouldn't take a context it seems
-- -- (functor) work with a function that takes a value and returns a value


-- map : (value -> value) -> (ValueAndContext value context -> ValueAndContext value context)
-- map valueToValueFunction =
--     wrapFunctionInContext valueToValueFunction


-- wrapFunctionInContext : (value -> value) -> ValueAndContext value context -> ValueAndContext value context
-- wrapFunctionInContext valueFunction context =
--     case context of
--         ValueAndContext value context ->
--             ValueAndContext (valueFunction value) context



-- -- (monad) work with a function that takes a value and returns a ValueAndContext


-- liftM : (value -> ValueAndContext value context) -> (ValueAndContext value context -> ValueAndContext value context)
-- liftM valueToContextFunction =
--     wrapFunctionInputInContextAndDiscardExistingContext valueToContextFunction


-- wrapFunctionInputInContextAndDiscardExistingContext : (value -> ValueAndContext value context) -> ValueAndContext value context -> ValueAndContext value context
-- wrapFunctionInputInContextAndDiscardExistingContext valueToContextFunction context =
--     case context of
--         ValueAndContext value context ->
--             valueToContextFunction value



-- -- applicatives (liftA) work with a (function + context), where the function takes a value and returns a value


-- liftA : ValueAndContext (value -> value) context -> (ValueAndContext value context -> ValueAndContext value context)
-- liftA valueFunctionAndContext =
--     case valueFunctionAndContext of
--         ValueAndContext valueFunction contextToDiscard ->
--             wrapFunctionInContext valueFunction



-- -- (no defintion that I know of) work with a function that takes a value and context and returns a value


-- mapReturn : (ValueAndContext value context -> value) -> (ValueAndContext value context -> ValueAndContext value context)
-- mapReturn contextToValueFunction =
--     wrapFunctionOutputInContext contextToValueFunction


-- wrapFunctionOutputInContext : (ValueAndContext value context -> value) -> ValueAndContext value context -> ValueAndContext value context
-- wrapFunctionOutputInContext contextToValueFunction context =
--     case context of
--         ValueAndContext value context2 ->
--             ValueAndContext (contextToValueFunction context) context2
