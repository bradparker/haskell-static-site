{-# LANGUAGE OverloadedStrings #-}

module Common
  ( home
  , Views
  ) where

import Miso (View, text, div_)

type Home = View ()

type Views = Home

home :: () -> View ()
home = const $ div_ [] [ text "Hello, world!" ]
