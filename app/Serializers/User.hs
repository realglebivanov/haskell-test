module Serializers.User (toView, UserView) where

import Data.Aeson
import Persistence.Schema (User(User), Entity(Entity))

newtype UserView = UserView (Entity User)

toView :: Entity User -> UserView
toView  = UserView

instance ToJSON UserView where
  toJSON (UserView (Entity id (User name email))) = object [
    "id" .= toJSON id,
    "name" .= name,
    "email" .= email ]
