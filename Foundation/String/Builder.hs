-- |
-- Module      : Foundation.String.Builder
-- License     : BSD-style
-- Maintainer  : Foundation
--
-- String Builder
--
-- This is extremely bad implementation of a builder implementation
-- but provide a very similar API to the future fast implementation;
-- So, in the spirit of getting started and to be able to start using
-- the API, we don't wait for the fast implementation.
module Foundation.String.Builder
    ( Builder
    , emit
    , emitChar
    , toString
    ) where

import           Basement.Compat.Base
import           Basement.Compat.Semigroup
import           Basement.String                (String)
import qualified Basement.String as S

data Builder = E String | T [Builder]

instance IsString Builder where
    fromString = E . fromString

instance Semigroup Builder where
    (<>) = append
instance Monoid Builder where
    mempty = empty
    mappend = append
    mconcat = concat

empty :: Builder
empty = T []

emit :: String -> Builder
emit s = E s

emitChar :: Char -> Builder
emitChar c = E (S.singleton c)

toString :: Builder -> String
toString = mconcat . flatten
  where
    flatten (E s) = [s]
    flatten (T l) = mconcat $ fmap flatten l

append :: Builder -> Builder -> Builder
append a b = T [a,b]

concat :: [Builder] -> Builder
concat = T
