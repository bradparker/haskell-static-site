{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeApplications #-}

module Common
  ( Action(..)
  , Routes
  , Home
  , Model(..)
  , components
  , home
  , homeURI
  , about
  , aboutURI
  , notFound
  ) where

import Data.Proxy (Proxy(Proxy))
import Miso
  ( Attribute
  , View
  , a_
  , defaultOptions
  , div_
  , emptyDecoder
  , href_
  , nav_
  , onWithOptions
  , preventDefault
  , text
  )
import Servant.API ((:<|>)((:<|>)), (:>))
import Servant.Links (URI, linkURI, safeLink)

onPreventClick :: Action -> Attribute Action
onPreventClick action =
  onWithOptions
    defaultOptions {preventDefault = True}
    "click"
    emptyDecoder
    (const action)

newtype Model = Model { uri :: URI }
  deriving Eq

data Action
  = ChangeURI URI
  | HandleURI URI
  | NoOp
  deriving (Show, Eq)

nav :: Model -> View Action
nav _ = nav_ []
  [ a_ [ href_ "/", onPreventClick (ChangeURI homeURI) ] [ text "Home" ]
  , a_ [ href_ "/about", onPreventClick (ChangeURI aboutURI) ] [ text "About" ]
  ]

type Home = View Action
type HomeComponent = Model -> View Action

homeURI :: URI
homeURI = linkURI $ safeLink (Proxy @ Routes) (Proxy @ Home)

home :: HomeComponent
home model = div_ [] [ nav model, text "Home" ]

type About = "about" :> View Action
type AboutComponent = Model -> View Action

about :: AboutComponent
about model = div_ [] [ nav model, text "About" ]

aboutURI :: URI
aboutURI = linkURI $ safeLink (Proxy @ Routes) (Proxy @ About)

notFound :: Model -> View Action
notFound model = div_ [] [ nav model, text "Not found" ]

type Routes = Home :<|> About

components :: HomeComponent :<|> AboutComponent
components = home :<|> about
