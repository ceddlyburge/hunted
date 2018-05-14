module Updates.ValueAndContext exposing (ValueAndContext(..), map, restoreContext)
-- we can't use a type alias within a type, I think this was the thing that was confusing me.
-- types don't have to be union types, they can just be a simple type
-- maybe make a pr to the elm repo with this.

type ValueAndContext valueType contextType
    = ValueAndContext valueType contextType

map : (a -> a) -> (ValueAndContext a b -> ValueAndContext a b)
map functionToMap =
    (\(ValueAndContext value context) -> ValueAndContext (functionToMap value) context)

restoreContext : (ValueAndContext value context -> value) -> (ValueAndContext value context -> ValueAndContext value context)
restoreContext contextToValueFunction =
    addContextToReturn contextToValueFunction

addContextToReturn : (ValueAndContext value context -> value) -> ValueAndContext value context -> ValueAndContext value context
addContextToReturn contextToValueFunction context =
    case context of
        ValueAndContext value context2 ->
            ValueAndContext (contextToValueFunction context) context2

