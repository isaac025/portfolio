{-# LANGUAGE FlexibleInstances #-}

module Pages.Software where

import Data.Text (Text)
import Lucid
import Pages.Base

instance ToHtml [(Int, Text, Text)] where
    toHtml [] = pure ()
    toHtml ((_, x, y) : xys) = do
        li_ [] $ do
            a_ [href_ y] (toHtml x)
        toHtml xys
    toHtmlRaw = toHtml

software :: [(Int, Text, Text)] -> Html ()
software ls = base $ do
    h1_ "Software"
    toHtml ls
