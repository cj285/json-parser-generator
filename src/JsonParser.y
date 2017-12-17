{
module JsonParser (parseJson) where

import JsonSyntax
import JsonLexer
import qualified Data.Map as DM

}

%name parseJson
%tokentype {Token}
%monad {Alex}
%lexer {lexer}{Token _ TEOF}

%token
  '{'         {Token _ TOpenBrace}
  '}'         {Token _ TCloseBrace}
  '['         {Token _ TOpenBracket}
  ']'         {Token _ TCloseBracket}
  ':'         {Token _ TColon}
  ','         {Token _ TComma}
  'true'      {Token _ TTrue}
  'false'     {Token _ TFalse}
  'null'      {Token _ TNull}
  Num         {Token _ TNum $$}
  Str         {Token _ TStr $$}

%name json
%%

Json : Object                   {$1}
      |Array                    {$1}

Array : '[' ']'                {JsonArr []}
       |'[' Elements ']'       {JsonArr $2}

Object : '{' '}'               {JsonMap $ DM.fromList []}
        |'{' Members '}'       {JsonMap $ DM.fromList $2}

Members : Pair                 {[$1]}
         |Pair ',' Members     {$1:$3}

Pair : Str ':' Value           {($1, $3)}

Elements : Value               {[$1]}
          |Value ',' Elements  {$1:$3}

Value : Object                 {$1}
       |Array                  {$1}
       |Str                    {JsonStr $1}
       |Num                    {JsonNum $1}
       |'true'                 {JsonBool True}
       |'false'                {JsonBool False}
       |'null'                 {JsonNull}

{

}
