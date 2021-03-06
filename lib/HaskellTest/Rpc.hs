module HaskellTest.Rpc (handle) where

import Network.JsonRpc.Server
import qualified Data.ByteString.Lazy.Char8 as B
import qualified Data.Aeson as Aeson
import qualified HaskellTest.Persistence.Repository as Repository
import qualified HaskellTest.Domain.User as User (new)
import HaskellTest.Serializers.User (UserView, toView)

import Control.Monad.IO.Class (liftIO)
import Data.Maybe (fromMaybe)
import HaskellTest.Persistence.Schema (Entity, User)

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
    f :: String -> String -> RpcResult Server UserView
    f name email = liftIO $ toView <$> Repository.insert (User.new name email)

index :: Method Server
index = toMethod "index" f ()
  where
    f :: RpcResult Server [UserView]
    f = liftIO $ map toView <$> (Repository.list :: IO [Entity User])
