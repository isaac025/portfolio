{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE RecordWildCards #-}

module App where

import Control.Monad.IO.Class
import Control.Monad.Reader
import Data.Aeson (FromJSON)
import Data.Maybe (fromMaybe)
import Data.Pool (Pool, newPool, withResource)
import Data.Pool.Internal (PoolConfig (..))
import Database.SQLite.Simple
import GHC.Generics (Generic)
import System.Environment (lookupEnv)

type DbPool = Pool Connection

newtype Env = Env DbPool

newtype Config = Config {db :: String}
    deriving (Generic)

instance FromJSON Config

newtype AppT a = AppT {unAppT :: ReaderT Env IO a}
    deriving (Functor, Applicative, Monad, MonadIO, MonadReader Env)

runAppT :: Env -> AppT a -> IO a
runAppT e (AppT a) = runReaderT a e

loadConfig :: (MonadIO m) => m Config
loadConfig = do
    mdb <- liftIO $ lookupEnv "PROD_DB"
    pure $ Config $ fromMaybe "test.db" mdb

mkEnv :: (MonadIO m) => Config -> m Env
mkEnv Config{..} = do
    p <- liftIO $ newPool (poolConfig db)
    pure $ Env p
  where
    poolConfig :: String -> PoolConfig Connection
    poolConfig str =
        PoolConfig
            { createResource = open str
            , freeResource = close
            , poolCacheTTL = 60
            , poolMaxResources = 10
            , poolNumStripes = Just 1
            }

withDbConnection :: DbPool -> (Connection -> IO a) -> AppT a
withDbConnection pool action = liftIO $ withResource pool action
