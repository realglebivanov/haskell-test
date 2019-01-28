{-# LANGUAGE GADTs #-}

module Persistence.Database (exec, insert, all) where

import Database.Persist.Postgresql as P (ConnectionString, SqlPersistT, IsSqlBackend)
import Database.Persist.Postgresql as P (withPostgresqlConn)
import Database.Persist.Sql as Sql (insert, selectList)
import Control.Monad.Reader (runReaderT, ReaderT, MonadIO)
import Control.Monad.Logger (runStdoutLoggingT, MonadLogger)
import Persistence.Schema (Entity)

all :: (MonadIO m, MonadLogger m) => SqlPersistT m [Entity r]
all = exec $ Sql.selectList [] []

insert record = exec $ Sql.insert record

exec action = runStdoutLoggingT $ P.withPostgresqlConn connString runAction
  where
    runAction backend = runReaderT action backend

connString :: ConnectionString
connString = "host=localhost port=5432 user=postgres password=postgres dbname=haskell_test"
