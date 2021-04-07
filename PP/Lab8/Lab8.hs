{-|
 - Paradigme de Programare CB
 - Laborator 8
 -}
module Lazy where

import Control.Exception (assert)

-- I. 1
naturals = [0 ..]

-- I. 2
evens = [0,2 ..]

-- I. 3
fibonacci :: Num a => [a]
fibonacci = 1:1:zipWith (+) (tail fibonacci) (fibonacci)


-- II
-- Puteți să vă folosiți de următoarea constantă în restul funcțiilor și să o
-- modificați într-un singur loc (aici) dacă doriți o precizie mai bună
tolerance = 0.001

-- II. 1
-- comportamentul ar trebui să fie identic cu cel al funcției "iterate", care
-- deja există în Prelude
build :: (a -> a) -> a -> [a]
build g a0 = a0:(build g (g a0))

-- II. 2
select :: (Num a, Ord a) => a -> [a] -> a
select e l = if abs (head l - head (tail l)) < e then head l else select e (tail l)

-- II. 3
phi :: Double
phi = select tolerance (filter (/=0) (zipWith (/) (tail fibonacci) (fibonacci)))

-- II. 4
pi' :: Double
pi' = select tolerance (1.5:zipWith (+) (tail pi') (sin (tail pi')))

-- II. 5
babylonianSqrt :: Double -> Double
babylonianSqrt = undefined

-- II. 6
newtonRaphson :: (Double -> Double) -> (Double -> Double) -> Double
newtonRaphson = undefined

-- II. 7. a
halves :: Double -> [Double]
halves = undefined

-- II. 7. b
diffs :: (Double -> Double) -> Double -> [Double]
diffs = undefined

-- II. 7. c
diff :: (Double -> Double) -> Double -> Double
diff = undefined

-- II. 8. a
areaT :: (Double -> Double) -> Double -> Double -> Double
areaT = undefined

-- II. 8. b
mid :: Double -> Double -> Double
mid a b = a + (b - a) / 2

addMid :: [Double] -> [Double]
addMid = undefined

-- II. 8. c
areas :: (Double -> Double) -> [Double] -> [Double]
areas = undefined

-- II. 8. d
integrate :: (Double -> Double) -> Double -> Double -> Double
integrate = undefined

-- TEST AREA --
class Approx a where
    approx :: Double -> a -> a -> Bool

instance Approx Double where
    approx e a b = abs (a - b) < e

instance (Approx a) => Approx [a] where
    approx _ [] [] = True
    approx e (x:xs) (y:ys) = approx e x y && approx e xs ys


(≈) :: (Approx a) => a -> a -> Bool
(≈) = approx (2 * tolerance)
infix 4 ≈

-- Approximate set membership
e ∈ s = any (e ≈) s
infix 4 ∈

-- Approximate multiple of
multipleOf m d = qr ≈ qi
    where qr = m / d
          qi = fromIntegral $ round $ m / d

testI1 = [
    assert (not . null $ naturals) "Success!",
    assert (head naturals == 0) "Success!",
    assert (naturals !! 1 == 1) "Success!",
    assert (naturals !! 7 == 7) "Success!",
    assert (naturals !! 200 == 200) "Success!"
    ]

testI2 = [
    assert (not . null $ evens) "Success!",
    assert (head evens == 0) "Success!",
    assert (evens !! 1 == 2) "Success!",
    assert (evens !! 7 == 14) "Success!",
    assert (evens !! 200 == 400) "Success!"
    ]

testI3 = [
    assert (not . null $ fibonacci) "Success!",
    assert (head fibonacci == 1) "Success!",
    assert (fibonacci !! 1 == 1) "Success!",
    assert (fibonacci !! 7 == 21) "Success!",
    assert (fibonacci !! 20 == 10946) "Success!"
    ]

testII3 = [
    assert (phi ≈ 1.61803398) "Success!"
    ]

testII4 = [
    -- pi already exists in Prelude
    assert (pi' ≈ pi) "Success!"
    ]

testII5 = [
    assert (babylonianSqrt 0 ≈ 0) "Success!",
    assert (babylonianSqrt 1 ≈ 1) "Success!",
    assert (babylonianSqrt 4 ≈ 2) "Success!",
    assert (babylonianSqrt 9 ≈ 3) "Success!",
    assert (babylonianSqrt 2 ≈ sqrt 2) "Success!",
    assert (babylonianSqrt 3 ≈ sqrt 3) "Success!",
    assert (babylonianSqrt pi ≈ sqrt pi) "Success!"
    ]

testII6 = [
    assert (newtonRaphson id (const 1) ≈ 0) "Success!",
    assert (newtonRaphson (2 *) (const 2) ≈ 0) "Success!",
    assert (newtonRaphson (+ 1) (const 1) ≈ -1) "Success!",
    assert (newtonRaphson ((-) 1) (const 1) ≈ 1) "Success!",
    assert (newtonRaphson (\x -> 2 * x + 1) (const 2) ≈ -0.5) "Success!",
    assert (newtonRaphson (** 2) (* 2) ≈ 0) "Success!",
    assert (newtonRaphson (\x -> x ** 2 - 1) (2 *) ∈ [-1, 1]) "Success!",
    assert (newtonRaphson (\x -> x ** 2 - 4) (2 *) ∈ [-2, 2]) "Success!",
    assert (newtonRaphson (\x -> x ** 2 - 2) (2 *) ∈ [- (sqrt 2), sqrt 2]) "Success!",
    assert (newtonRaphson sin cos `multipleOf` pi) "Success!",
    assert ((newtonRaphson cos (negate . sin) + pi/2) `multipleOf` pi) "Success!"
    ]

testII7a = [
    assert (and $ zipWith (≈) (halves 0) [0, 0, 0, 0]) "Success!",
    assert (halves 0 !! 100 == 0) "Success!",
    assert (and $ zipWith (≈) (halves 8) [8, 4, 2, 1]) "Success!",
    assert (and $ zipWith (≈) (halves 1) [1, 0.5, 0.25, 0.125]) "Success!"
    ]

testII7c = [
    assert (diff id 1 ≈ 1) "Success!",
    assert (diff id 2 ≈ 1) "Success!",
    assert (diff (** 2) 1 ≈ 2) "Success!",
    assert (diff (** 2) 2 ≈ 4) "Success!",
    assert (diff (\x -> x ** 2 + 1) 2 ≈ 4) "Success!",
    assert (diff (\x -> x ** 2 + 1337) 2 ≈ 4) "Success!",
    assert (diff sin 0 ≈ 1) "Success!",
    assert (diff sin pi ≈ -1) "Success!",
    assert (diff sin (pi/2) ≈ 0) "Success!",
    assert (diff sin (pi/4) ≈ (sqrt 2) / 2) "Success!",
    assert (diff sin (pi/4) ≈ sin (pi/4)) "Success!",
    assert (diff cos 0 ≈ 0) "Success!",
    assert (diff cos pi ≈ 0) "Success!",
    assert (diff cos (pi/2) ≈ -1) "Success!",
    assert (diff cos (pi/4) ≈ -(cos (pi/4))) "Success!"
    ]

testII8a = [
    assert (areaT id 0 1 ≈ 0.5) "Success!",
    assert (areaT id 0 10 ≈ 50) "Success!",
    assert (areaT id 1 10 ≈ 49.5) "Success!",
    assert (areaT id 3 8 ≈ 27.5) "Success!",
    assert (areaT id 1.5 2 ≈ 0.875) "Success!",
    assert (areaT (+1) 0 1 ≈ 1.5) "Success!",
    assert (areaT (*2) 0 1 ≈ 1.0) "Success!",
    assert (areaT (** 2) 0 1 ≈ 0.5) "Success!",
    assert (areaT (** 2) 2 6 ≈ 80) "Success!",
    assert (areaT sqrt 2 6 ≈ 7.72740) "Success!",
    assert (areaT exp 1 3 ≈ 22.80381) "Success!",
    assert (areaT sin 10 20 ≈ 1.844620) "Success!",
    assert (areaT cos 10 20 ≈ -2.15494733) "Success!"
    ]

testII8b = [
    assert (addMid [1, 3] ≈ [1, 2, 3]) "Success!",
    assert (addMid [1, 2] ≈ [1, 1.5, 2]) "Success!",
    assert (addMid [1, 10] ≈ [1, 5.5, 10]) "Success!",
    assert (addMid [1, 3, 5] ≈ [1, 2, 3, 4, 5]) "Success!",
    assert (take 10 (addMid evens) ≈ take 10 naturals) "Success!"
    ]

testII8c = [
    assert (areas id [1, 2] ≈ [1.5]) "Success!",
    assert (areas id [1, 8] ≈ [31.5]) "Success!",
    assert (areas id [0, 7] ≈ [24.5]) "Success!",
    assert (areas (+ 1) [0, 7] ≈ [31.5]) "Success!",
    assert (areas (* 2) [0, 7] ≈ [49]) "Success!",
    assert (areas (** 2) [0, 7] ≈ [171.5]) "Success!",
    assert (areas sin [0, 7, 14] ≈ [2.29945, 5.766657]) "Success!",
    assert (areas sin [1..5] ≈ [0.87538, 0.525208, -0.30784, -0.8578]) "Success!",
    assert (areas cos [1..5] ≈ [0.06207, -0.7030, -0.821818, -0.18499]) "Success!"
    ]

testII8d = [
    assert (integrate id 0 1 ≈ 0.5) "Success!",
    assert (integrate id 1 1 ≈ 0) "Success!",
    assert (integrate id 5 5 ≈ 0) "Success!",
    assert (integrate id 1 2 ≈ 1.5) "Success!",
    assert (integrate id 1 10 ≈ 49.5) "Success!",
    assert (integrate (+ 1) 1 10 ≈ 58.5) "Success!",
    assert (integrate (* 2) 1 10 ≈ 99) "Success!",
    assert (integrate (** 2) 1 10 ≈ 333) "Success!",
    assert (integrate (2 **) 1 10 ≈ 1474.4354) "Success!",
    assert (integrate sin 1 4 ≈ 1.19307) "Success!",
    assert (integrate cos 1 4 ≈ -1.5971) "Success!",
    assert (integrate atan 1 4 ≈ 3.4465) "Success!",
    assert (integrate sqrt 3 7 ≈ 8.88221) "Success!"
    ]

allTests = [testI1, testI2, testI3, testII3, testII4, testII5, testII6,
            testII7a, testII7c, testII8a, testII8b, testII8c, testII8d]

runAll = mapM_ runTest allTests
runTest test = mapM_ putStrLn test
