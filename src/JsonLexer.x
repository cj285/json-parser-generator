{
module JsonLexer where

import Prelude hiding (lex)
import Control.Monad ( liftM )
}

%wrapper "monad"

$digit = 0-9
$alpha = [a-zA-Z]
$escape = [\"\\\/n]

@natdef = $digit+
@intdef = @natdef | '-' @natdef
@decdef = '.' @natdef
@expdef = [eE][\-\+]$digit+
@numdef = @intdef | @intdef @decdef | @intdef @expdef | @intdef @decdef @expdef
@strdef = \\$escape | [^\"\n]

token :-
  $white+           ;
  "//".*            ;
  "{"              {lex' TOpenBrace}
  "}"              {lex' TCloseBrace}
  "["              {lex' TOpenBracket}
  "]"              {lex' TCloseBracket}
  ":"              {lex' TColon}
  ","              {lex' TComma}
  "null"           {lex' TNull}
  "true"           {lex' TTrue}
  "false"          {lex' TFalse}
  @numdef          {lex $ TNum . read}
  \" @strdef \"    {lex $ TStr . init . tail}

{
data Token = Token AlexPosn JsonToken deriving ( Show )
data JsonToken = TEOF
                |TOpenBrace
                |TCloseBrace
                |TOpenBracket
                |TCloseBracket
                |TColon
                |TComma
                |TNull
                |TTrue
                |TFalse
                |TNum Double
                |TStr String
                deriving (Eq, Show)

alexEOF :: Alex Token
alexEOF = do
  (p,_,_,_) <- alexGetInput
  return $ Token p TEOF

lex :: (String -> JsonToken) -> AlexAction Token
lex f = \(p,_,_,s) i -> return $ Token p (f (take i s))

lex' :: JsonToken -> AlexAction Token
lex' = lex . const

lexer::(Token -> Alex a) -> Alex a
lexer cont = alexMonadScan >>= cont
}
