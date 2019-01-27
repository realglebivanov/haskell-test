module Http (start) where

import Web.Scotty
import qualified Rpc (handle)
import Control.Monad.IO.Class (liftIO)

start :: IO ()
start = scotty 3000 $ do
  get "/rpc" $ do
    body >>= \content -> (liftIO $ Rpc.handle content) >>= raw
