module Rpc (handle) where

import Network.JsonRpc.Server
import qualified Data.ByteString.Lazy.Char8 as B
import Data.Maybe (fromMaybe)
import Control.Monad.Trans (liftIO)
import Control.Monad.Reader (ReaderT, ask, runReaderT)
import Control.Concurrent.MVar (MVar, newMVar, modifyMVar)
import qualified User
import qualified Data.Aeson as Aeson
import qualified Persistence.Database
import qualified Persistence.Schema

type Server = ReaderT (MVar Int) IO

handle :: B.ByteString -> IO B.ByteString
handle request = createMVar >>= runMethod >>= makeResponse
  where
    createMVar = newMVar 0 :: IO (MVar Int)
    runMethod = runReaderT (call methods request)
    makeResponse response = return $ fromMaybe defaultResponse response
    defaultResponse = "" :: B.ByteString

methods :: [Method Server]
methods = [create, index]

create :: Method Server
create = toMethod "create" f params
  where
    params = Required "name" :+: Required "email" :+: ()
    f :: String -> String -> RpcResult Server String
    f name email = liftIO $ Database.insert $ User.new name email

index :: Method Server
index = toMethod "index" f ()
  where
    f :: RpcResult Server Int
    f = Database.all :: [Schema.Entity User.User]

