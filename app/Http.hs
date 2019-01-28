module Http (start) where

import Web.Scotty
import qualified Rpc (handle)
import Control.Monad.IO.Class (liftIO)

start :: IO ()
start = scotty 3000 $ do
  get "/rpc" $ do
    body >>= content >>= raw
      where
        content body = (liftIO $ Rpc.handle body)
