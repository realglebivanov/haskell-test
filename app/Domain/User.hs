module Domain.User (User, new) where

import Persistence.Schema (User(User))

new :: String -> String -> User
new = User
