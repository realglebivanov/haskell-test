module HaskellTest.Persistence.Schema (User(User), Entity(Entity), migrateAll) where

import Database.Persist
import Database.Persist.Postgresql
import Database.Persist.TH

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
User sql=users
  name String
  email String
  deriving Show Eq
|]
