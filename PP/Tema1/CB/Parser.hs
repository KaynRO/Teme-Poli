module Parser
where

import Util
import Data.Maybe
import Data.String
import InferenceDataType
import Data.Map (Map)
import qualified Data.Map as Map
import ClassState
-- Definire Program

data Program = Prog(Map (String) (String, ClassState))
initEmptyProgram :: Program
initEmptyProgram = Prog (Map.insert "Global" ("Global", initEmptyClass) Map.empty)

insertIntoProgram :: Program -> String->String->ClassState-> Program
insertIntoProgram (Prog program) nume nume_parinte clasa = Prog (Map.insert (nume) (nume_parinte, clasa) program)



getVars :: Program -> [[String]]
getVars (Prog program) = getValues (snd (Map.findWithDefault ("XX", initEmptyClass) "Global" (program) )) Var

getClasses :: Program -> [String]
getClasses (Prog program) = Map.keys program

getParentClass :: String -> Program -> String
getParentClass nume (Prog program) =  fst( (Map.findWithDefault ("XXX", initEmptyClass) nume (program)) )

getFuncsForClass :: String -> Program -> [[String]]
getFuncsForClass nume (Prog program) = getValues (snd ( (Map.findWithDefault ("XXX", initEmptyClass) nume (program)) )) Func

replace :: String -> String
replace [] = []
replace s 
        | head(s) == ',' = " " ++ replace(tail (s))
        | head(s) == ')' = " " ++ replace(tail (s))
        | head(s) == '(' = " " ++ replace(tail (s))
        | head(s) == ':' = " " ++ replace(tail (s))
        | head(s) == '=' = " " ++ replace(tail (s))
        | otherwise = head(s):replace(tail(s))
findClass :: String-> Program -> Bool
findClass nume (Prog program) 
                            | null( filter (==nume) (getClasses (Prog program)) ) == True = False
                            | otherwise = True


            
-- Instruction poate fi ce considerați voi
type Instruction = [String]

parse :: String -> [Instruction]
parse p = map words (map replace (lines(p)))


interpret :: Instruction -> Program -> Program
interpret  instructiune (Prog program)
                 | (head(instructiune) == "class") && (null(drop 2 (instructiune)) )= insertIntoProgram (Prog program) (head(tail(instructiune))) ("Global") (initEmptyClass)
                 | head(instructiune) == "class" = insertIntoProgram (Prog program) (head(tail(instructiune)) ) (last(instructiune)) initEmptyClass
                 | (head(instructiune) == "newvar") && 
                    (findClass (last(instructiune)) (Prog program) ) = 
                    insertIntoProgram 
                    (Prog program)
                    ("Global")
                    ("Global")
                    (insertIntoClass
                    (snd (Map.findWithDefault ("XX", initEmptyClass) "Global" (program) )) 
                    (Var)
                    ([head(tail(instructiune)), last(instructiune)]) )
                 
infer :: Expr -> Program -> Maybe String
infer = undefined

