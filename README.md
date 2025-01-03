# purescript-safe-printf

[![Build Status](https://travis-ci.org/kcsongor/purescript-safe-printf.svg?branch=master)](https://travis-ci.org/kcsongor/purescript-safe-printf)

A bare-bones proof of concept implementation of a typesafe printf-like interface
where the format string is provided as a type-level string.

This library uses the 0.15 version of the compiler.

## Example

```purescript
format @"Hi %s! Your favourite number is %d" "Bill" 16
```

produces the string

```
"Hi Bill! Your favourite number is 16"
```

<!--
*** TODO: Commenting this section out because
*** - the `:t` output in the REPL is not as nice as it used to be apparently
*** - no need to use Proxy at all, so wildcard trick doesn't apply
***
*** ```
*** > import Data.Printf (format)
*** > :t format @"Hi %s! Your favourite number is %d"
*** forall (@fun :: Type). Format "Hi %s! Your favourite number is %d" fun => fun
*** ```


A function of the "right type" is generated from the format string, so that

```
:t format (SProxy :: SProxy "Hi %s! Your favourite number is %d")
```

gives
```
String -> Int -> String
```

You can also choose to use wildcards if you don't want to repeat yourself:

```purs
  let formatted = format (SProxy :: _ "Hi %s! You are %d") "Bill" 12
```
-->

## TODO

Currently only "%d" and "%s" are supported, without any other fancy formatting.
