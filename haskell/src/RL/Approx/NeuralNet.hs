{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE OverloadedLists #-}

-- | Use Neural Network to approximate the value function



module RL.Approx.NeuralNet where

import           Numeric.LinearAlgebra                    ( (#>)
                                                          , (<.>)
                                                          , (><)
                                                          , Matrix
                                                          , R
                                                          , Vector
                                                          , cmap
                                                          , inv
                                                          , scalar
                                                          , size
                                                          , tr'
                                                          , (|>)
                                                          )



data NeuralNet n = NeuralNet
  { ϕ :: !(n -> Vector R)
    -- ^ Get the inputs to score using a neural network in the required format
  , layers :: [ Layer ]
    -- ^ Describes the underlying neural net for scoring the input
  }

data Layer = Layer
  {
    weights :: Matrix R,
    activation :: (R -> R) 
  }

scoreLayer :: Layer -> Vector R -> Vector R
scoreLayer Layer { weights, activation } input = cmap activation ( tr' weights #> input )

-- Need to look at the foldr and needing to flip the order
scoreNeuralNetwork :: Vector R -> [Layer] -> Vector R
-- scoreNeuralNetwork input lls = foldr (.) id (map (flip scoreLayer lls) input 
scoreNeuralNetwork input lls = foldr (.) id (map scoreLayer lls) input 


-- Create a simple test
-- input x = [1, 1, 1]
-- NeuralNet n =

sampleInput :: Vector R
sampleInput = [1, 1, 1]

-- llayers = [ Matrix [ [] [] [] ] }

layer :: Layer
layer = Layer{ weights = (3><3) [1, 0, 0,
                                    0, 1, 0,
                                    0, 0, 1
                                   ],
                  activation = id
                }

llayers :: [Layer]
llayers = [ layer 
          ]

score1 = scoreNeuralNetwork sampleInput llayers


layers2 = [layer, layer]
score2 = scoreNeuralNetwork sampleInput layers2
