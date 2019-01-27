module Migrations (main) where

import Database.Persist.Postgresql (runMigration)
import Persistence.Database (exec)
import Persistence.Schema (migrateAll)

main :: IO ()
main = exec $ runMigration migrateAll
