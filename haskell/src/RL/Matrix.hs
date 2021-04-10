-- | Matrix operations useful for RL operations.
module RL.Matrix where

import           Control.Monad                            ( replicateM )

import           Numeric.LinearAlgebra                    ( Matrix
                                                          , R
                                                          , Vector
                                                          )
import qualified Numeric.LinearAlgebra                   as Matrix

import           Test.QuickCheck                          ( Gen
                                                          , arbitrary
                                                          , choose
                                                          )

-- | Return a vector that's equal to the sum of the rows of a matrix.
--
-- @
-- λ> sumRows $ (2><2) [0..3]
-- [1.0, 5.0]
-- @
sumRows :: Matrix R -> Vector R
sumRows = Matrix.fromList . map Matrix.sumElements . Matrix.toRows

-- | Are all the elements of @a@ and @b@ within the given ϵ?
--
-- For example, for matrices a and b this checks:
--
-- ∀i. ∀j. |aᵢⱼ - bᵢⱼ| ≤ ϵ
--
-- Raises an exception if the matrices have incompatible dimensions.
allWithin :: (Ord a, Matrix.Container c a, Num (c a))
          => a
          -- ^ ϵ
          -> c a
          -- ^ a
          -> c a
          -- ^ b
          -> Bool
allWithin ϵ a b = Matrix.maxElement (abs (a - b)) <= ϵ

-- * QuickCheck

-- | Generate data for random matrices ranging from 1×1 to 100×100.
matrixRows' :: Gen [[R]]
matrixRows' = do
  n <- choose (1, 100)
  m <- choose (1, 100)
  replicateM m (replicateM n arbitrary)
