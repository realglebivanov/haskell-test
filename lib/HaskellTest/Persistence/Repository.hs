module HaskellTest.Persistence.Repository (exec, list, insert) where

import Database.Persist.Postgresql (ConnectionString, SqlPersistT, SqlBackend)
import Database.Persist.Postgresql (withPostgresqlConn)
import Database.Persist.Class (insertEntity, selectList, PersistEntityBackend, PersistEntity)
import Control.Monad.IO.Unlift (MonadUnliftIO)
import Control.Monad.Logger (MonadLogger, LoggingT, runStdoutLoggingT)
import Control.Monad.Reader (runReaderT)
import HaskellTest.Persistence.Schema (Entity)
import HaskellTest.Configs.Repository (connectionString)

list :: (MonadUnliftIO m, PersistEntity r, PersistEntityBackend r ~ SqlBackend) =>
  m [Entity r]
list = exec $ selectList [] []

insert :: (MonadUnliftIO m, PersistEntity r, PersistEntityBackend r ~ SqlBackend) =>
  r -> m (Entity r)
insert record = exec $ insertEntity record

exec :: (MonadUnliftIO m) => SqlPersistT (LoggingT m) a -> m a
exec action = runStdoutLoggingT $ connectionString >>= exec'
  where
    exec' connString = withPostgresqlConn connString (runReaderT action)
