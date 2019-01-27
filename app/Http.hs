module Http (start) where

import Scotty
import qualified Rpc ()

start :: IO ()
start = scotty 3000 $ do
  get "/rpc/:test" >>= param "test" >>= \p -> html join ["You have written:", p]

