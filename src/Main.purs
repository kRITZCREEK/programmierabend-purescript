module Main where

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Console
import Control.Monad.Cont.Trans
import Control.Monad.Except.Trans
import Data.Function
import Data.Either

type Player = { name :: String, age :: Number }
type Team = { x :: Player, y :: Player }
type Match = { green :: Team, black :: Team }
type Error = String

type Async eff = ContT Unit (Eff eff)
type AsyncErr eff = ExceptT Error (Async eff)

foreign import findPlayerPS :: forall eff.
  Fn3
  Int
  (Player -> Eff eff Unit)
  (Error -> Eff eff Unit)
  (Eff eff Unit)

findPlayer :: forall eff.
  Int ->
  (Either Error Player -> Eff eff Unit) ->
  Eff eff Unit
findPlayer userId cb =
  runFn3 findPlayerPS userId (cb <<< Right) (cb <<< Left)

buildTeam :: Player -> Player -> Team
buildTeam p1 p2 = { x: p1, y: p2}

--buildMatch :: Team -> Team -> Match
--buildMatch t1 t2 = { green: t1 , black: t2 }

buildTeamA :: forall eff.
  Int -> Int ->
  (Either Error Team -> Eff eff Unit) ->
  Eff eff Unit
buildTeamA idx idy cb = findPlayer idx (\x ->
  case x of
    Right x' -> findPlayer idy (\y ->
      case y of
        Right y' -> cb (Right (buildTeam x' y'))
        Left err -> cb (Left err)
    )
    Left err -> cb (Left err)
  )

findPlayerCont :: forall eff. Int -> Async eff (Either Error Player)
findPlayerCont uid = ContT (findPlayer uid)

findPlayerContEx :: forall eff. Int -> AsyncErr eff Player
findPlayerContEx uid = ExceptT (findPlayerCont uid)

buildTeamCont :: forall eff. Int -> Int -> Async eff (Either Error Team)
buildTeamCont idx idy = do
  x <- findPlayerCont idx
  case x of
    Right x' -> do
      y <- findPlayerCont idy
      case y of
        Right y' -> return (Right (buildTeam x' y'))
        Left err -> return (Left err)
    Left err -> return (Left err)

buildTeamContEx :: forall eff. Int -> Int -> AsyncErr eff Team
buildTeamContEx idx idy = do
  x <- findPlayerContEx idx
  y <- findPlayerContEx idy
  return (buildTeam x y)

--logName :: forall eff. User -> Eff (console :: CONSOLE | eff) Unit
handlePlayer (Right u) = log u.name
handlePlayer (Left err) = log err

handleTeam (Right p) = log (p.x.name ++ " and " ++ p.y.name)
handleTeam (Left err) = log err

main = do
  -- findPlayer 1 handlePlayer
  -- runContT (findPlayerCont 1) handlePlayer
  runContT (runExceptT (findPlayerContEx 1)) handlePlayer
  -- buildTeam 0 3 handleTeam
  runContT (runExceptT (buildTeamContEx 0 3)) handleTeam
