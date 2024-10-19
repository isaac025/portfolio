module Pages.Stories where

import Data.Text (Text)
import Lucid
import Pages.Base

stories :: [Text] -> Html ()
stories ls =
    base $ do
        h1_ "Short Stories"
        ul_ [] $ do
            toHtml ls
