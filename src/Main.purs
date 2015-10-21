module Main where

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Console
import Control.Monad.Cont.Trans
import Control.Monad.Except.Trans
import Data.Function
import Data.Either

type Console = Eff (console :: CONSOLE) Unit

foreign import findPlayerPS :: forall eff.
  Fn3
  Int
  (Player -> Eff eff Unit)
  (Error -> Eff eff Unit)
  (Eff eff Unit)

findPlayer :: Int -> (Either Error Player -> Console) -> Console
findPlayer playerId cb =
  runFn3 findPlayerPS playerId (cb <<< Right) (cb <<< Left)































--------------
-- Datentypen

type Player = { name :: String, age :: Int }
type Team = { x :: Player, y :: Player }
type Error = String

-- findPlayer :: Int -> (Eiher Error Player -> Console) -> Console

handlePlayer :: Either Error Player -> Console
handlePlayer (Right p) = log p.name
handlePlayer (Left err) = log err

handleTeam :: Either Error Team -> Console
handleTeam (Right t) = log (t.x.name ++ " and " ++ t.y.name)
handleTeam (Left err) = log err

team :: Player -> Player -> Team
team p1 p2 = { x: p1, y: p2 }

buildTeam :: Int -> Int -> (Either Error Team -> Console) -> Console
buildTeam idx idy cb = log "Not implemented!"































