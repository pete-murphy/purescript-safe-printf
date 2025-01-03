module Test.Main where

import Prelude

import Data.Printf (format)
import Effect (Effect)
import Test.Assert (assert)

main :: Effect Unit
main = do
  let formatted = format @"Hi %s! You are %d" "Bill" 12
  assert (formatted == "Hi Bill! You are 12")
