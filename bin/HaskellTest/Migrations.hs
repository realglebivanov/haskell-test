module HaskellTest.Migrations (main) where

import Database.Persist.Postgresql (runMigration)
import HaskellTest.Persistence.Repository (exec)
import HaskellTest.Persistence.Schema (migrateAll)

main :: IO ()
main = exec $ runMigration migrateAll
