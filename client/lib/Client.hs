{-# LANGUAGE OverloadedStrings #-}

module Client
  ( main
  ) where

import Common (home)
import qualified Miso

main :: IO ()
main =
  Miso.startApp Miso.App
    { Miso.initialAction = ()
    , Miso.model = ()
    , Miso.update = const Miso.noEff
    , Miso.view = home
    , Miso.events = Miso.defaultEvents
    , Miso.subs = []
    , Miso.mountPoint = Just "app"
    }
