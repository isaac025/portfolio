module Pages.Home where

import Lucid
import Pages.Base

home :: Html ()
home = base $ do
    h1_ [] "Isaac Hiram Lopez Diaz"
    p_ [] "I'm a software engineer from Caguas, PR."
    p_ [] "I'm currently pursuing a Master's at UPR-RP."
    p_ [] "My interests are: Haskell, Functional and Programming Languages, Formal Methods, and Computer Architecture"
    ul_ [] $ do
        li_ [] $ do
            a_ [href_ "/home"] "Home"
        li_ [] $ do
            a_ [href_ "/software"] "Software that I've built"
        li_ [] $ do
            a_ [href_ "/stories"] "Short Stories (mostly in Spanish)"
        li_ [] $ do
            a_ [] "Essays/Blog"
