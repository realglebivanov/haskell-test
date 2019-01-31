module HaskellTest.Configs.Repository (connectionString) where

import System.Envy
import Database.PostgreSQL.Simple (postgreSQLConnectionString, ConnectInfo(..))

import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Maybe (fromMaybe)
import Data.ByteString (ByteString)

instance DefConfig ConnectInfo where
  defConfig = ConnectInfo {
    connectHost = "localhost",
    connectPort = 5432,
    connectPassword = "postgres",
    connectUser = "postgres",
    connectDatabase = "haskell_test"
  }

instance FromEnv ConnectInfo where
  fromEnv = gFromEnvCustom Option {
    customPrefix = "PG",
    dropPrefixCount = 7
  }


connectionString :: (MonadIO m) => m ByteString
connectionString = liftIO $ postgreSQLConnectionString <$> pgConfig

pgConfig :: IO ConnectInfo
pgConfig = fromMaybe (defConfig :: ConnectInfo) <$> (decode :: IO (Maybe ConnectInfo))
