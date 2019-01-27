{-# LANGUAGE OverloadedStrings #-}

module Rpc (handle) where

import Network.JsonRpc.Server
import qualified Data.ByteString.Lazy.Char8 as B
import Data.Maybe (fromMaybe)
import Control.Monad (forM_)
import Control.Monad.Trans (liftIO)
import Control.Monad.Reader (ReaderT, ask, runReaderT)
import Control.Concurrent.MVar (MVar, newMVar, modifyMVar)
import qualified User
import qualified Data.Aeson as Aeson

type Server = ReaderT (MVar [User.User]) IO

handle :: String -> IO B.ByteString
handle request = fromMaybe $ runReaderT (call methods request) (newMVar [])

methods :: [Method Server]
methods = [create, index]

defaultResponse :: B.ByteString
defaultResponse = ""

create :: Method Server
create = toMethod "create" f params
  where
    params = Required "name" :+: Required "email" :+: ()
    f :: String -> String -> RpcResult Server String
    f name email = liftIO $ return.show $ User.new name email

index :: Method Server
index = toMethod "index" f ()
  where
    f :: RpcResult Server [User.User]
    f = ask >>= \users -> liftIO $ return users

