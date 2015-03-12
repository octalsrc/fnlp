module NLP.Crubadan (readCrData) where


import qualified Data.Map as M
import qualified Data.Text as T
import Text.ParserCombinators.Parsec

import Data.NGram
import NLP.Freq

crTriGramFile :: FreqMap (TriGram NGToken) -> String
crTriGramFile = prettyprint

readCrData :: String -> IO (FreqMap (TriGram NGToken))
readCrData fpath = 
  do s <- readFile fpath 
     let ngs = (fmap M.fromList . parse triGramFile "err") s
     return (case ngs of
               Right fm -> fm
               Left e -> error (show e))


triGramFile :: GenParser Char st [(TriGram NGToken, Frequency)]
triGramFile = do result <- many line
                 eof
                 return result

line = do a <- noneOf "\n "
          b <- noneOf "\n "
          c <- noneOf "\n "
          char ' '
          freq <- many (noneOf "\n")
          char '\n'
          return (TriGram (toTok a) (toTok b) (toTok c), read freq)

