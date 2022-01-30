{-# LANGUAGE OverloadedStrings #-}

-- |
module Config where

import XMonad

mainXMonad =
  xmonad
    defaultConfig
      { terminal = "${kitty}/bin/kitty",
        modMask = mod4Mask,
        borderWidth = 3
      }

main = do
  mainXMonad
