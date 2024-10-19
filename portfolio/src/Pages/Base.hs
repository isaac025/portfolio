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
                nav_ [] $ do
                    h
                    ul_ [] $ do
                        li_ [] $ do
                            a_ [href_ "/home"] "Home"
                        li_ [] $ do
                            a_ [href_ "/software"] "Software that I've built"
                        li_ [] $ do
                            a_ [href_ "/stories"] "Short Stories (mostly in Spanish)"
                    footer
  where
    footer = do
        hr_ []
        p_ [] $ do
            a_ [href_ "http://validator.w3.org/check/referer"] $ do
                img_ [src_ "http://www.w3.org/Icons/valid-html401", alt_ "Valid HTML 4.01!", height_ "31", width_ "88"]
