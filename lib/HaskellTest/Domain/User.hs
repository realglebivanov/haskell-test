module HaskellTest.Domain.User (User, new) where

import HaskellTest.Persistence.Schema (User(User))

new :: String -> String -> User
new = User
