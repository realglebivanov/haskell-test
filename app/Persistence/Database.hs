{-# LANGUAGE GADTs #-}

module Persistence.Database (exec) where

import Database.Persist.Postgresql as P (ConnectionString, SqlPersistT, IsSqlBackend)
import Database.Persist.Postgresql as P (withPostgresqlConn, insert)
import Control.Monad.Reader (runReaderT)
import Control.Monad.Logger (runStdoutLoggingT)

insert record = exec $ P.insert record

exec action = runStdoutLoggingT $ P.withPostgresqlConn connString runAction
  where
    runAction backend = runReaderT action backend

connString :: ConnectionString
connString = "host=localhost port=5432 user=postgres password=postgres dbname=haskell_test"
