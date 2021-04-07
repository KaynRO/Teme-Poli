{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE EmptyDataDecls, MultiParamTypeClasses,
             TypeSynonymInstances, FlexibleInstances,
             InstanceSigs #-}


module Bloxorz where

import ProblemState
import TestPP()
import Data.Array

{-
    Caracterele ce vor fi printate pentru fiecare tip de obiect din joc 
    Puteți înlocui aceste caractere cu orice, în afară de '\n'.
-}

hardTile :: Char
hardTile = '▒'

softTile :: Char
softTile = '='

block :: Char
block = '▓'

switch :: Char
switch = '±'

emptySpace :: Char
emptySpace = ' '

winningTile :: Char
winningTile = '*'

{-
    Sinonim de tip de date pentru reprezetarea unei perechi (int, int)
    care va reține coordonatele de pe tabla jocului
-}

type Position = (Int, Int)

{-
    Direcțiile în care se poate mișcă blocul de pe tablă
-}

instance Num Position where
    (+) (a,b) (c,d) = (a + c, b + d)


data Directions = North | South | West | East
    deriving (Show, Eq, Ord)

{-
    *** TODO ***

    Tip de date care va reprezenta plăcile care alcătuiesc harta și switch-urile
-}

data Cell = Build (String, String, [Position]) deriving (Eq, Ord)

firstC :: Cell -> String
firstC (Build (x, _, _)) = x

secondC :: Cell -> String
secondC (Build (_, x, _)) = x

thirdC :: Cell -> [Position]
thirdC (Build (_, _, x)) = x

instance Show Cell where
    show cell = firstC cell
{-
    *** TODO ***

    Tip de date pentru reprezentarea nivelului curent
-}

data Level = Lvl (Array Position Cell) deriving (Eq, Ord)

instance Show Level where
    show (Lvl level) = "\n" ++ (concat $map (\x -> concat (map firstC x) ++ "\n") $[take no $drop (no * i) $elems level | i <- [0..maxX]])
                            where maxY = snd $snd $bounds level
                                  no = 1 + maxY
                                  maxX = fst $snd $bounds level


{-
    *** Opțional *** 
  
    Dacă aveți nevoie de o funcționalitate particulară, 
    instantiati explicit clasele Eq și Ord pentru Level. 
    În cazul acesta, eliminați deriving (Eq, Ord) din Level. 
-}

{-
    *** TODO ***

    Instantiati Level pe Show. 

    Atenție! String-ul returnat va fi urmat și precedat de un rând nou. 
    În cazul în care jocul este câștigat, la sfârșitul stringului se va mai
    concatena mesajul "Congrats! You won!\n". 
    În cazul în care jocul este pierdut, se va mai concatena "Game Over\n". 
-}

{-
    *** TODO ***

    Primește coordonatele colțului din dreapta jos a hârtii și poziția inițială a blocului.
    Întoarce un obiect de tip Level gol.
    Implicit, colțul din stânga sus este (0, 0).
-}

emptyLevel :: Position -> Position -> Level
emptyLevel pos1 pos2 = Lvl $(array ((0,0), pos1)) [ if (i,j) == pos2 then ((i,j), Build([block], [hardTile], [])) else ((i,j), Build ([emptySpace], [emptySpace], [])) | i <- [0..fst pos1], j <- [0..snd pos1]]

{-
    *** TODO ***

    Adaugă o celulă de tip Tile în nivelul curent.
    Parametrul char descrie tipul de tile adăugat: 
        'H' pentru tile hard 
        'S' pentru tile soft 
        'W' pentru winning tile 
-}

changeTile :: Cell -> Position -> Level -> Level
changeTile cell pos (Lvl level) = Lvl $array (bounds level) (map(\x -> if fst x /= pos then x else if firstC (snd x) == [block] then ((fst x),Build(firstC (snd x), secondC cell, thirdC cell)) else (fst x, cell)) (assocs level))

addTile :: Char -> Position -> Level -> Level
addTile tile pos (Lvl level)
            | tile == 'H' = changeTile (Build ([hardTile], [hardTile], [])) pos $Lvl level
            | tile == 'S' = changeTile (Build ([softTile], [hardTile], [])) pos $Lvl level
            | otherwise = changeTile (Build ([winningTile], [winningTile], [])) pos $Lvl level


{-
    *** TODO ***

    Adaugă o celulă de tip Swtich în nivelul curent.
    Va primi poziția acestuia și o listă de Position
    ce vor desemna pozițiile în care vor apărea sau 
    dispărea Hard Cells în momentul activării/dezactivării
    switch-ului.
-}

addSwitch :: Position -> [Position] -> Level -> Level
addSwitch pos attrib (Lvl level) = changeTile (Build ([switch], [switch], attrib)) pos $Lvl level

{-
    === MOVEMENT ===
-}

{-
    *** TODO ***

    Activate va verifica dacă mutarea blocului va activa o mecanică specifică. 
    În funcție de mecanica activată, vor avea loc modificări pe hartă. 
-}

activate :: Cell -> Level -> Level
activate cell (Lvl level) = if firstC cell == [switch] then level1 else (Lvl level)
                                where list = assocs level
                                      finalList = map (\x -> if elem (fst x) (thirdC cell) then (fst x, Build([softTile], [softTile], [])) else x) list
                                      level1 = Lvl $array (bounds level) finalList
{-
    *** TODO ***

    Mișcarea blocului în una din cele 4 direcții 
    Hint: Dacă jocul este deja câștigat sau pierdut, puteți lăsa nivelul neschimbat.
-}

getBlocks :: Level -> Array Position Cell
getBlocks (Lvl level) = $filter (\x -> firstC (snd x) == [block]) (assocs level)

getPosType :: Position -> Level -> String
getPosType pos (Lvl level) = firstC $snd $head $filter (\x -> fst x == pos) (assocs level)

getPosPrev :: Position -> Level -> String
getPosPrev pos (Lvl level) = secondC $snd $head $filter (\x -> fst x == pos) (assocs level)

isPosOk :: Position -> Level -> Bool
isPosOk (x, y) (Lvl level) = x >= 0 && y >= 0 && x <= (fst maxx) && y <= (snd maxx)
                            where maxx = snd $bounds level

movCell :: (Position, Cell) -> Direction -> Level
movCell (blockPos, cell) dire (Lvl level) = (Lvl level)
                                        where
                                            blockPrev = snd cell
                                            newPos = blockPos + case dire of
                                                                    North -> (-1, 0)
                                                                    South -> (1, 0)
                                                                    West -> (0, -1)
                                                                    East -> (0, 1)
                                            level1 = if isPosOk newPos level then changeTile (Build([block], getPosType newPos level, [])) newPos level else level
                                            level2 = if level1 /= level then  changeTile (Build([hardTile], blockPrev, [])) blockPos level1 else level
move :: Directions -> Level -> Level
move dire level = level2


{-
    *** TODO ***

    Va returna True dacă jocul nu este nici câștigat, nici pierdut.
    Este folosită în cadrul Interactive.
-}

continueGame :: Level -> Bool
continueGame (Lvl level) = if prevType == [emptySpace] then False else True
                            where blockPos = getBlockPos (Lvl level)
                                  prevType = secondC $level ! blockPos

{-
    *** TODO ***

    Instanțiați clasa `ProblemState` pentru jocul nostru. 
  
    Hint: Un level câștigat nu are succesori! 
    De asemenea, puteți ignora succesorii care 
    duc la pierderea unui level.
-}

instance ProblemState Level Directions where
    successors = undefined

    isGoal = undefined

    -- Doar petru BONUS
    -- heuristic = undefined
