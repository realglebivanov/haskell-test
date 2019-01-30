module HaskellTest.Http (start) where

import Web.Scotty
import qualified HaskellTest.Rpc as Rpc (handle)
import Control.Monad.IO.Class (liftIO)

start :: IO ()
start = scotty 3000 $ do
  post "/rpc" $ do
    body >>= content >>= raw
      where
        content body = liftIO $ Rpc.handle body
