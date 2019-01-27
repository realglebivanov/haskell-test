{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE StandaloneDeriving #-}

module User (User, new) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)
import Persistence.Schema (User(User))

deriving instance Generic User
instance FromJSON User
instance ToJSON User

new :: String -> String -> User
new = User
