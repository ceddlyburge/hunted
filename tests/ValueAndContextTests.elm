module ValueAndContextTests exposing (..)

import Test exposing (..)
import Fuzz exposing (float, int, string)
import Expect
import Updates.ValueAndContext exposing (..)

-- map takes an Value -> Value function, and returns a (ValueAndContext Value a)-> (ValueAndContext Value a) function. The returned function applies the passed function to the value parameter of the ValueAndContext
valueAndContextTest : Test
valueAndContextTest  =
    describe "map"
        [ fuzz2 float string "map applies function to value and leaves context unchanged" <|
            \value context ->
                let
                    functionToMap = \x -> x / 2
                in
                    ValueAndContext value context
                    |> map functionToMap
                    |> Expect.equal (ValueAndContext (functionToMap value) context)
        ,fuzz2 float string "mapping identity equals identity (functor law)" <|
            \value context ->
                let 
                    valueAndContext = ValueAndContext value context    
                in
                    valueAndContext
                    |> map identity
                    |> Expect.equal (identity(valueAndContext))
        ]

identity : a -> a
identity x = 
    x