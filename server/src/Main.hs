{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module Main
  ( main
  ) where

import Common (Action, Model(..), Routes, about, aboutURI, home, homeURI)
import Data.Proxy (Proxy(Proxy))
import qualified GHCJSDevServer
import qualified Lucid
import Lucid (ToHtml(..))
import Miso (ToServerRoutes)
import qualified Network.Wai.Handler.Warp as Warp
import Servant (Server, serve)
import Servant.API ((:<|>)((:<|>)))

type App = ToServerRoutes Routes Document Action

newtype Document a = Document a

instance ToHtml a => ToHtml (Document a) where
  toHtmlRaw = toHtml
  toHtml (Document a) = do
    Lucid.doctype_
    Lucid.html_ $ do
      Lucid.head_ $ do
        Lucid.title_ "A web app"
        Lucid.meta_ [ Lucid.charset_ "utf8" ]
        Lucid.with (Lucid.script_ "") [ Lucid.src_ "/rts.js" ]
        Lucid.with (Lucid.script_ "") [ Lucid.src_ "/lib.js" ]
        Lucid.with (Lucid.script_ "") [ Lucid.src_ "/out.js" ]
        Lucid.with (Lucid.script_ "") [ Lucid.src_ "/runmain.js", Lucid.defer_ "true" ]
      Lucid.body_ $ toHtml a

server :: Server App
server = homeHandler :<|> aboutHandler
  where
     homeHandler = pure $ Document $ home $ Model homeURI
     aboutHandler = pure $ Document $ about $ Model aboutURI

main :: IO ()
main = do
  let options =
        GHCJSDevServer.Options
          { GHCJSDevServer.name = "client"
          , GHCJSDevServer.execName = "client"
          , GHCJSDevServer.sourceDirs =
              ["./client/lib", "./client/dev", "./common/lib"]
          , GHCJSDevServer.buildDir = "./.build"
          , GHCJSDevServer.defaultExts = []
          }
  middleware <- snd <$> GHCJSDevServer.makeMiddleware options
  Warp.run 8080 $ middleware $ serve (Proxy @ App) server
