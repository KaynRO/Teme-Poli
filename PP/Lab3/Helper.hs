{-|
 - Paradigme de Programare CB
 - Laborator 3
 -}
module Helper where

l0  = "        ***** **            ***** **    "
l1  = "     ******  ****        ******  ****   "
l2  = "    **   *  *  ***      **   *  *  ***  "
l3  = "   *    *  *    ***    *    *  *    *** "
l4  = "       *  *      **        *  *      ** "
l5  = "      ** **      **       ** **      ** "
l6  = "      ** **      **       ** **      ** "
l7  = "    **** **      *      **** **      *  "
l8  = "   * *** **     *      * *** **     *   "
l9  = "      ** *******          ** *******    "
l10 = "      ** ******           ** ******     "
l11 = "      ** **               ** **         "
l12 = "      ** **               ** **         "
l13 = "      ** **               ** **         "
l14 = " **   ** **          **   ** **         "
l15 = "***   *  *          ***   *  *          "
l16 = " ***    *            ***    *           "
l17 = "  ******              ******            "
l18 = "    ***                 ***             "

img = [l0,l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15,l16,l17,l18]

m1 = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
m2 = [[1, 0, 0], [0, 1, 1], [1, 0, 1]]

summ1m2 = [[2,2,3],[4,6,7],[8,8,10]]
prodm1m2 = [[4,2,5],[10,5,11],[16,8,17]]

-- functii care printeaza intr-un mod human-readable o matrice sau o imagine
display :: (Show a) => ([a] -> String) -> [[a]] -> IO ()
display displayLine = putStr . foldr (++) "" . map displayLine

-- folositi pentru a afisa o matrice de numere (ex. 1)
displayMat :: (Show a) => [[a]] -> IO ()
displayMat = display (foldr (\x acc -> show x ++ "   " ++ acc) "\n")

-- folositi pentru a afisa o "imagine" - matrice de siruri (ex. 2)
displayImg :: [String] -> IO ()
displayImg = display (++ "\n")
