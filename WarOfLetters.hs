initialBoard :: [[Char]] -- define initial the layout of board
initialBoard = 
  [ ['X', 'A', '-', '-', 'X'],
    ['B', '-', '-', '-', 'Z'],
    ['X', 'C', '-', '-', 'X']
  ]

-- printing a row with 5 cells
displayRow :: [Char] -> IO ()
displayRow row = do
  putStrLn ([row !! 0] ++ " " ++ 
            [row !! 1] ++ " " ++ 
            [row !! 2] ++ " " ++ 
            [row !! 3] ++ " " ++
            [row !! 4])

-- drawing the board with 3 rows
drawBoard :: [[Char]] -> IO ()
drawBoard board = do
  displayRow (board !! 0)
  displayRow (board !! 1)
  displayRow (board !! 2)

-- get the input from user of the total max moves allowed 
getMaxMoves :: IO Int
getMaxMoves = do
  putStrLn "Enter the maximum number of total moves allowed:"
  input <- getLine
  let maxMoves = read input :: Int
  return maxMoves

-- deciding who starts first
getStartingPlayer :: IO String
getStartingPlayer = do
  putStrLn "Who starts first? Type 'firsts' or 'last':"
  input <- getLine
  if input == "firsts" || input == "last"
    then return input
    else do
      putStr "Invalid input! "
      getStartingPlayer

-- mapping a flat cell index from 0 to 14
getCoordinates :: Int -> (Int, Int)
getCoordinates n = (countRows n, countCols n)

-- determines the row number
countRows :: Int -> Int
countRows n = if n < 5 then 0 else if n < 10 then 1 else 2

-- determines the col number
countCols :: Int -> Int
countCols n = if n < 5 then n else if n < 10 then n - 5 else n - 10

-- fins the position letter on the board
findLetterPos :: [[Char]] -> Char -> (Int, Int)
findLetterPos board letter = findLetterPosHelper board letter 0

findLetterPosHelper :: [[Char]] -> Char -> Int -> (Int, Int)
findLetterPosHelper board letter index =
  let (row, col) = getCoordinates index
  in if (board !! row !! col) == letter
     then (row, col)
     else findLetterPosHelper board letter (index + 1)

-- Replace one character in a row at a given column
changeRow :: Int -> Char -> [Char] -> [Char]
changeRow col newVal row = changeRowHelper row col newVal 0

changeRowHelper :: [Char] -> Int -> Char -> Int -> [Char]
changeRowHelper [] _ _ _ = []
changeRowHelper (cell:rest) targetCol newVal currentIndex =
  if currentIndex == targetCol
    then newVal : (changeRowHelper rest targetCol newVal (currentIndex + 1))
    else cell : (changeRowHelper rest targetCol newVal (currentIndex + 1))

-- update the board after by changing a particular cell
updateBoardCell :: Int -> Int -> Char -> [[Char]] -> [[Char]]
updateBoardCell row col newVal board = updateBoardHelper board row col newVal 0

updateBoardHelper :: [[Char]] -> Int -> Int -> Char -> Int -> [[Char]]
updateBoardHelper [] _ _ _ _ = []
updateBoardHelper (currentRow:restRows) targetRow targetCol newVal currentRowIndex =
  if currentRowIndex == targetRow
    then (changeRow targetCol newVal currentRow) : (updateBoardHelper restRows targetRow targetCol newVal (currentRowIndex + 1))
    else currentRow : (updateBoardHelper restRows targetRow targetCol newVal (currentRowIndex + 1))

-- check if move is valid by rules
isValidMove :: [[Char]] -> Char -> (Int, Int) -> (Int, Int) -> Bool
isValidMove board letter (fromRow, fromCol) (toRow, toCol) =
  (board !! toRow !! toCol) == '-' &&
  abs (fromRow - toRow) <= 1 && abs (fromCol - toCol) <= 1 &&
  (if letter == 'Z' then True else toCol >= fromCol)

-- prompt based on who is playing (firsts or last)
getPlayerInput :: String -> Int -> IO (Char, Int)
getPlayerInput firstPlayer currentMove = do
  let isFirstTurn = (firstPlayer == "firsts" && even currentMove) || (firstPlayer == "last" && odd currentMove)
  if isFirstTurn
    then do
      putStrLn "Please select one of the first three letters and a cell (e.g., A 6):"
      input <- getLine
      let parts = words input
      if length parts /= 2
        then do
          putStrLn "Invalid move!"
          getPlayerInput firstPlayer currentMove
        else do
          let letter = head (parts !! 0)
          let cellNum = read (parts !! 1) :: Int
          return (letter, cellNum)
    else do
      putStrLn "Please select a cell for the Z:"
      input <- getLine
      let cellNum = read input :: Int
      return ('Z', cellNum)

zWins :: [[Char]] -> Bool -- Z win condition
zWins board =
  let (_, zcol) = findLetterPos board 'Z'
      (_, acol) = findLetterPos board 'A'
      (_, bcol) = findLetterPos board 'B'
      (_, ccol) = findLetterPos board 'C'
  in zcol < acol && zcol < bcol && zcol < ccol

firstsWin :: [[Char]] -> Bool -- firsts win condition
firstsWin board =
  let (zr, zc) = findLetterPos board 'Z'
      possibleMoves = [ (r, c) | r <- [zr-1..zr+1], c <- [zc-1..zc+1], r >= 0, r < 3, c >= 0, c < 5, not (r == zr && c == zc)]
  in not (any (\(r,c) -> (board !! r !! c) == '-') possibleMoves)

-- main game
runGame :: [[Char]] -> Int -> Int -> String -> IO ()
runGame board currentMove maxMoves firstPlayer = do
  drawBoard board
  if currentMove == maxMoves then do
    putStrLn "Game ended: Draw!" -- draw if reached max moves
    drawBoard board
  else do
    (letter, cellNum) <- getPlayerInput firstPlayer currentMove -- get player input
    let (row, col) = getCoordinates cellNum
    let (oldRow, oldCol) = findLetterPos board letter
    if isValidMove board letter (oldRow, oldCol) (row, col) then do -- check if valid 
      let clearedBoard = updateBoardCell oldRow oldCol '-' board -- move the letter
      let updatedBoard = updateBoardCell row col letter clearedBoard
      if zWins updatedBoard then do -- check if wins
        drawBoard updatedBoard
        putStrLn "Z wins!"
        drawBoard updatedBoard
      else if firstsWin updatedBoard then do
        drawBoard updatedBoard
        putStrLn "A&B&C win!"
        drawBoard updatedBoard
      else
        runGame updatedBoard (currentMove + 1) maxMoves firstPlayer -- next turn
    else do -- invalid move
      putStrLn "Invalid move!"
      runGame board (currentMove + 1) maxMoves firstPlayer

-- start of program 
main :: IO ()
main = do
  let board = initialBoard
  putStrLn "Welcome!"
  drawBoard board
  maxMoves <- getMaxMoves
  firstPlayer <- getStartingPlayer
  runGame board 0 maxMoves firstPlayer