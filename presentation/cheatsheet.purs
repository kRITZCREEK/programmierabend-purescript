buildTeam :: Int -> Int -> (Either Error Team -> Console) -> Console
buildTeam idx idy cb = findPlayer idx \x' ->
  case x' of
    Left err -> cb (Left err)
    Right x -> findPlayer idy \y' ->
      case y' of
        Left err -> cb (Left err)
        Right y -> cb (Right (team x y))

findPlayerCont uid = ContT (findPlayer uid)

buildTeamCont idx idy = do
  x <- findPlayerCont idx
  case x of
    Left err -> return (Left err)
    Right x' -> do
      y <- findPlayerCont idy
      case y of
        Left err -> return (Left err)
        Right y' -> return (Right (team x' y'))

findPlayerContEx pid = ExceptT (findPlayerCont pid)

buildTeamContEx idx idy = do
  x <- findPlayerContEx idx
  y <- findPlayerContEx idy
  return (team x y)
