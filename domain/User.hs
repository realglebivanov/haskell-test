{-# LANGUAGE DeriveGeneric #-}

module User (User, new, name, email) where

import GHC.Generics (Generic)
import Data.Aeson (ToJSON, FromJSON)

data User = User {
  name :: String,
  email :: String
} deriving (Show, Eq, Generic)

instance FromJSON User
instance ToJSON User

new :: String -> String -> User
new = User
