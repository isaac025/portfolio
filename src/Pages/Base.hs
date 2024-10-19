{-# LANGUAGE FlexibleInstances #-}

module Pages.Base where

import Data.Text (Text)
import Lucid

instance ToHtml [Text] where
    toHtml [] = pure ()
    toHtml (x : xs) = do
        li_ [] $ do
            a_ [] (toHtml x)
        toHtml xs
    toHtmlRaw = toHtml

base :: Html () -> Html ()
base h = do
    doctypehtml_ $ do
        html_ $ do
            body_ $ do
                h
