{-# LANGUAGE OverloadedStrings #-}

import Control.Applicative ((<$>))
import Data.Monoid
import qualified Data.Set as Set
import Text.Pandoc.Options
import Hakyll
import qualified GHC.IO.Encoding as E

main :: IO ()
main = do
    E.setLocaleEncoding E.utf8
    hakyll $ do
    
        match "site-src/static/css/**" $ route staticRoute >> compile compressCssCompiler
        
        match "site-src/static/favicon.ico" $ route staticRoute >> compile copyFileCompiler
        
        match "site-src/static/*.md" staticMarkdownRule
        
        match "site-src/blog-content/resources/**" $ route baseRoute >> compile copyFileCompiler
                
        match "site-src/blog-content/posts/*" $ do
            route $ baseRoute `composeRoutes` setExtension "html"
            compile $ pandocCompiler'
                >>= loadAndApplyTemplate "site-src/templates/post.html" postCtx
                >>= saveSnapshot "content"
                >>= loadAndApplyTemplate "site-src/templates/default.html" postCtx
                >>= relativizeUrls
        
        create ["posts.html"] $ do
            route idRoute
            compile $ do
                let archiveCtx =
                        field "posts" (const $ postList recentFirst)    `mappend`
                        constField "title" "Posts"                      `mappend`
                        defaultContext
                
                makeItem ""
                    >>= loadAndApplyTemplate "site-src/templates/posts.html" archiveCtx
                    >>= loadAndApplyTemplate "site-src/templates/default.html" archiveCtx
                    >>= relativizeUrls
                
        match "site-src/index.html" $ do
            route baseRoute
            compile $ do
                let indexCtx = field "post" $ const (itemBody <$> mostRecentPost)
                let homeCtx = constField "title" "Home" `mappend` defaultContext
        
                getResourceBody
                    >>= applyAsTemplate indexCtx
                    >>= loadAndApplyTemplate "site-src/templates/default.html" homeCtx
                    >>= relativizeUrls
            
        match "site-src/templates/*" $ compile templateCompiler

baseRoute :: Routes
baseRoute = gsubRoute "site-src/" (const "") `composeRoutes` gsubRoute "blog-content/" (const "")

extensions :: Set.Set Extension
extensions = Set.fromList [Ext_inline_notes, Ext_raw_html, Ext_tex_math_dollars]

mostRecentPost :: Compiler (Item String)
mostRecentPost = head <$> (recentFirst =<< loadAllSnapshots "site-src/blog-content/posts/*" "content")

pandocCompiler' :: Compiler (Item String)
pandocCompiler' = pandocCompilerWith pandocMathReaderOptions pandocMathWriterOptions

pandocMathReaderOptions :: ReaderOptions
pandocMathReaderOptions = defaultHakyllReaderOptions {
        readerExtensions = Set.union (readerExtensions defaultHakyllReaderOptions) extensions
    }

pandocMathWriterOptions :: WriterOptions
pandocMathWriterOptions  = defaultHakyllWriterOptions {
        writerExtensions = Set.union (writerExtensions defaultHakyllWriterOptions) extensions,
        writerHTMLMathMethod = MathJax ""
}

postCtx :: Context String
postCtx = dateField "date" "%B %e, %Y" `mappend` defaultContext

postList :: ([Item String] -> Compiler [Item String]) -> Compiler String
postList sortFilter = do
    posts   <- sortFilter =<< loadAll "site-src/blog-content/posts/*"
    itemTpl <- loadBody "site-src/templates/post-item.html"
    applyTemplateList itemTpl postCtx posts

staticMarkdownRule :: Rules ()
staticMarkdownRule = do
    route $ staticRoute `composeRoutes` setExtension "html"
    compile $ pandocCompiler'
        >>= loadAndApplyTemplate "site-src/templates/default.html" defaultContext
        >>= relativizeUrls

staticRoute :: Routes
staticRoute = baseRoute `composeRoutes` gsubRoute "static/" (const "")
