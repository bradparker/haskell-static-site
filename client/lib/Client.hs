{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module Client
  ( main
  ) where

import Common (Action(..), Model(..), Routes, components, notFound)
import Data.Proxy (Proxy(Proxy))
import Miso (Effect, View, (<#))
import qualified Miso

view :: Model -> View Action
view model =
  case Miso.runRoute (Proxy @ Routes) components uri model of
    Left _ -> notFound model
    Right rendered -> rendered

update :: Action -> Model -> Effect Action Model
update (HandleURI u) model = Miso.noEff model { uri = u }
update (ChangeURI u) model = model <# (NoOp <$ Miso.pushURI u)
update NoOp m = Miso.noEff m

main :: IO ()
main =
  Miso.miso $ \currentUri ->
    Miso.App
      { Miso.initialAction = NoOp
      , Miso.model = Model currentUri
      , Miso.update = update
      , Miso.events = Miso.defaultEvents
      , Miso.subs = [ Miso.uriSub HandleURI ]
      , Miso.mountPoint = Nothing
      , Miso.view = view
      }
