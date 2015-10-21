module Main where

import Prelude

import Control.Monad.Cont.Trans
import Control.Monad.Eff
import Control.Monad.Eff.Console
import Control.Monad.Except.Trans
import Data.Either
import Data.Function

type Console = Eff (console :: CONSOLE) Unit

foreign import findPlayerPS :: forall eff.
  Fn3
  Int
  (Player -> Eff eff Unit)
  (Error -> Eff eff Unit)
  (Eff eff Unit)

findPlayerJS :: Int -> (Either Error Player -> Console) -> Console
findPlayerJS playerId cb =
  runFn3 findPlayerPS playerId (cb <<< Right) (cb <<< Left)



-- Datentypen
type Player = { name :: String, age :: Int }
type Team = { x :: Player, y :: Player }
type Error = String

-- Helfer
handlePlayer :: Either Error Player -> Console
handlePlayer (Right p) = log ("Der Spieler: " ++ p.name)
handlePlayer (Left err)     = log ("Ein Fehler: " ++ err)

handleTeam :: Either Error Team -> Console
handleTeam (Right t)  = log ("Das Team: " ++ t.x.name ++ " & " ++ t.y.name)
handleTeam (Left err) = log ("Ein Fehler: " ++ err)

team :: Player -> Player -> Team
team p1 p2 = { x: p1, y: p2 }

-- Applikationslogik
findPlayer pid = findPlayerJS pid

buildTeamImpl idx idy cb = log "Not implemented"

buildTeam :: Int -> Int -> (Either Error Team -> Console) -> Console
buildTeam idx idy cb = buildTeamImpl idx idy cb
