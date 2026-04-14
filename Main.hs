import System.IO

type Student = (String, Int, Int)

main :: IO ()
main = do
    putStrLn "1. Check In"
    putStrLn "2. Search"
    putStrLn "3. Calculate Time"
    putStrLn "4. Check Out"
    putStrLn "5. Exit"
    option <- getLine
    menu option

menu :: String -> IO ()
menu "1" = checkIn >> main
menu "2" = searchStudent >> main
menu "3" = calculateTime >> main
menu "4" = checkOut >> main
menu "5" = putStrLn "Bye!"
menu _   = putStrLn "Invalid option" >> main

readStudents :: IO [Student]
readStudents = do
    content <- readFile "University.txt"
    return (map read (lines content))

writeStudents :: [Student] -> IO ()
writeStudents students =
    writeFile "University.txt" (unlines (map show students))

checkIn :: IO ()
checkIn = do
    putStrLn "ID:"
    id <- getLine
    putStrLn "Entry time:"
    entry <- getLine
    students <- readStudents
    let newStudent = (id, read entry, -1)
    writeStudents (newStudent : students)
    putStrLn "Student added"

searchStudent :: IO ()
searchStudent = do
    putStrLn "ID:"
    id <- getLine
    students <- readStudents
    let result = filter (\(i,_,s) -> i == id && s == -1) students
    if null result
        then putStrLn "Not found or already out"
        else print (head result)

calculateTime :: IO ()
calculateTime = do
    putStrLn "ID:"
    id <- getLine
    students <- readStudents
    let result = filter (\(i,_,s) -> i == id && s /= -1) students
    if null result
        then putStrLn "Not found or still inside"
        else do
            let (_, entry, exit) = head result
            print (exit - entry)

checkOut :: IO ()
checkOut = do
    putStrLn "ID:"
    id <- getLine
    putStrLn "Exit time:"
    exitStr <- getLine
    students <- readStudents

    let exitTime = read exitStr
    let exists = any (\(i,_,s) -> i == id && s == -1) students

    if not exists
        then putStrLn "Student not found or already out"
        else do
            let updatedStudents = map (\(i,e,s) ->
                    if i == id && s == -1
                        then (i, e, exitTime)
                        else (i, e, s)
                ) students
            writeStudents updatedStudents
            putStrLn "Check out done"