module JsonSyntax where
import qualified Data.Map as Map
{-
  object
    {}
    { members }
  members
    pair
    pair , members
  pair
    string : value
  array
    []
    [ elements ]
  elements
    value
    value , elements
  value
    string
    number
    object
    array
    true
    false
    null
-}

data JSON = JsonNull
            | JsonNum Double
            | JsonBool Bool
            | JsonString String
            | JsonArr [JSON]
            | JsonMap (Map.Map String JSON)
            deriving (Eq, Ord, Show)
