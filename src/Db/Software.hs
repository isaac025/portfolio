{-# LANGUAGE RecordWildCards #-}

module Db.Software where

import App
import Control.Monad.IO.Class
import Control.Monad.Reader
import Data.Text (Text)
import Database.SQLite.Simple

class (Monad m) => Software m where
    getSoftwares :: m [(Int, Text, Text)]

--    getSoftwareByName :: Text -> m [(Int, Text, Text)]
--    getSoftwareById :: Int -> m (Maybe (Text, Text))

instance Software AppT where
    getSoftwares = do
        (Env p) <- ask
        withDbConnection p $ \conn -> liftIO $ query_ conn "SELECT * FROM software"
