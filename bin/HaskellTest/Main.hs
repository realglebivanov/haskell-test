module HaskellTest.Main (main) where

import qualified HaskellTest.Http

main :: IO ()
main = HaskellTest.Http.start
