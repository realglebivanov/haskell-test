module Rpc (handle) where

import Network.JsonRpc.Server
import qualified Data.ByteString.Lazy.Char8 as B
import Data.Maybe (fromMaybe)
import Control.Monad.Trans (liftIO)
import qualified User
import qualified Data.Aeson as Aeson
import qualified Persistence.Database

type Server = IO

handle :: B.ByteString -> IO B.ByteString
handle request = runMethod >>= makeResponse
  where
    runMethod = call methods request
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
    f :: RpcResult Server String
    f = liftIO $ (Database.all :: [Schema.Entity User.User]) >>= encode
      where
        encode users = return $ Aeson.encode users

