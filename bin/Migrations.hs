module Migrations (main) where

import Database.Persist.Postgresql (runMigration)
import Persistence.Repository (exec)
import Persistence.Schema (migrateAll)

main :: IO ()
main = exec $ runMigration migrateAll
