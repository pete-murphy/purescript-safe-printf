module Data.Printf where

import Prelude (identity, (<>), show)
import Prim.Symbol as Symbol
import Type.Prelude (class IsSymbol, Proxy(..), reflectSymbol)

class Format (string :: Symbol) fun | string -> fun where
  format :: fun

instance
  ( Parse string format
  , FormatF format fun
  ) =>
  Format string fun where
  format = formatF (FProxy :: FProxy format) ""

class FormatF (format :: FList) fun | format -> fun where
  formatF :: FProxy format -> String -> fun

instance FormatF FNil String where
  formatF _ = identity

instance
  FormatF rest fun =>
  FormatF (FCons D rest) (Int -> fun) where
  formatF _ str = \i -> formatF (FProxy :: FProxy rest) (str <> show i)

instance
  FormatF rest fun =>
  FormatF (FCons S rest) (String -> fun) where
  formatF _ str = \s -> formatF (FProxy :: FProxy rest) (str <> s)

instance
  ( IsSymbol lit
  , FormatF rest fun
  ) =>
  FormatF (FCons (Lit lit) rest) fun where
  formatF _ str = formatF (FProxy :: FProxy rest) (str <> reflectSymbol (Proxy :: _ lit))

--------------------------------------------------------------------------------
class Parse (string :: Symbol) (format :: FList) | string -> format

foreign import data FList :: Type
foreign import data FNil :: FList
foreign import data FCons :: Specifier -> FList -> FList

data FProxy (f :: FList) = FProxy

instance Parse "" (FCons (Lit "") FNil)
else instance (Symbol.Cons h t string, Match h t fl) => Parse string fl

class Match (head :: Symbol) (tail :: Symbol) (out :: FList) | head tail -> out

instance Match a "" (FCons (Lit a) FNil)
else instance
  ( Symbol.Cons h t s
  , MatchFmt h spec
  , Parse t rest
  ) =>
  Match "%" s (FCons (Lit "") (FCons spec rest))
else instance
  ( Parse s (FCons (Lit acc) r)
  , Symbol.Cons o acc rest
  ) =>
  Match o s (FCons (Lit rest) r)

class MatchFmt (head :: Symbol) (out :: Specifier) | head -> out

instance MatchFmt "d" D
instance MatchFmt "s" S

-- TODO: add more of these...
foreign import data Specifier :: Type
foreign import data D :: Specifier
foreign import data S :: Specifier
foreign import data Lit :: Symbol -> Specifier
