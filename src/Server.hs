{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Server (runApp) where

import App
import Control.Monad.IO.Class
import Db.Software
import Lucid
import Network.Wai.Handler.Warp
import Pages
import Servant
import Servant.HTML.Lucid

type HomeApi = "home" :> Get '[HTML] (Html ())
type StoriesApi = "stories" :> Get '[HTML] (Html ())
type SoftwareApi = "software" :> Get '[HTML] (Html ())

type Api = HomeApi :<|> StoriesApi :<|> SoftwareApi

server :: ServerT Api AppT
server = homeHandler :<|> storiesHandler :<|> softwareHandler
  where
    homeHandler :: AppT (Html ())
    homeHandler = pure home

    storiesHandler :: AppT (Html ())
    storiesHandler = pure $ stories ["story 1", "story 2"]

    softwareHandler :: AppT (Html ())
    softwareHandler = software <$> getSoftwares
api :: Proxy Api
api = Proxy

appToHandler :: Env -> AppT a -> Handler a
appToHandler env a = liftIO $ runAppT env a

appServer :: Env -> Server Api
appServer env = hoistServer api (appToHandler env) server

app :: Env -> Application
app env = serve api (appServer env)

runApp :: IO ()
runApp = do
    c <- loadConfig
    env <- mkEnv c
    run 8080 (app env)
