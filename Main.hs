module Synthesis where

import Prelude
import Data.Array as Array
import Data.List as List

data LabelTerm =  Labelof String -- label of var
                | Obj String   -- object label
                deriving (Show, Eq)

-- must add support for more general function application over terms
data IntTerm =  Zero -- integer base constant
              | Suc IntTerm -- successor function
              | Count LabelTerm --count of number of elements with a given label
              deriving (Show, Eq)

data Formula =  Top
              | Bot
              | LabRel String LabelTerm LabelTerm
              | IntRel String IntTerm IntTerm
              | And Formula Formula
              | Or Formula Formula
              | Implies Formula Formula
              | Not Formula
              | A String Formula -- universal quantifier
              | E String Formula -- existential quantifier
              deriving (Show, Eq)
---------------------------------------------------------------------------

vars :: Int -> [String]
vars 0 = []
vars val = ["x" ++ (show val)] ++ (vars (val - 1))

labels :: Int -> [String]
labels 0 = []
labels val = ["l" ++ (show val)] ++ (labels (val - 1))
----------------------------------------------------------------------------

labrels = ["EqLabel"]
intrels = ["EqInt", "LessInt"]
varslist = vars 3
labelslist = labels 3
---------------------------------------------------------------------------

nodupappend :: Eq a => a -> [a] -> [a]
nodupappend e lst = if elem e lst then lst else lst ++ [e]

lstunion :: Eq a => [a] -> [a] -> [a]
lstunion = \lst1 lst2 -> foldr nodupappend lst1 lst2
----------------------------------------------------------------------------

{-
- The implementation below may be made more efficient(?) by precomputing
pairs of formulas for conjunctive, disjunctive, and implication
forms. There's also repetition in computing negation forms (and other
similar places such as base predicates), as the
only formulas whose negation will be in k but not in k-1 are those
of the formulas in k-1 but not in k-2.

- Dynamic programming for relation symbols and terms has also been implemented, but not very efficiently.
They should ideally be within qf_formula itself so that they're not computed for each step of the dp
implementation at the formula level.

- Similar to formulae, terms also repeat greatly between successive cost values. Must look into more
efficient implementation.

- IMPORTANT: Must modify dp procedure to accomodate functionally specified costs for terms/formulae.
--- Lower costs expressed as smaller numbers versus negative costs?
-}

{-
Cost model:
- Formulae are evaluated for cost only on the quantifier-free part.
- True and False are worth nothing.
- Boolean operators are all worth 1.
- Constants are worth 1.
- Relation symbols themselves are worth 1.
- Function symbols themselves are worth 1.
- Each variable of LabelTerm type is worth 1.
- Total cost is additive in terms of written expression upon these above rules, for the most part.
-}

-- The functions below are meant to capture terms/formulae below a certain cost

-- Label terms: constant cost. Therefore not defined explicitly here.
--qf_formula_labterms :: Int -> [LabelTerm]

-- Label relations below a given cost
qf_formula_labrels :: Int -> [Formula]
qf_formula_labrels k = if k < 3 then [] else [LabRel rel lt1 lt2 | rel <- labrels, lt1 <- labelterms, lt2 <- labelterms]
                        where labelterms = [Obj label | label <- labelslist] ++ [Labelof var | var <- varslist]


-- Returns an array of entries of integer terms below a cost value (from costs of 1 until input value)
qf_formula_intterms :: Int -> Array Int [IntTerm]
qf_formula_intterms measure = dparray
    where
    dpcomp 1 = [Zero]
    dpcomp 2 = [Zero, Suc Zero] ++ [Count label | label <- labelterms]
    dpcomp k = [Suc intterm | intterm <- (dparray ! (k-1))]
    labelterms = [Obj label | label <- labelslist] ++ [Labelof var | var <- varslist]
    valarray = Array.listArray (1, measure) [dpcomp cost | cost <- [1..measure]]
    dparray = Array.listArray (1, measure) [foldr (\i lst -> lstunion lst (valarray ! i)) [] [1..cost] | cost <- [1..measure]]

-- Integer relations below a given cost. Relation symbols have constant cost 1.
qf_formula_intrels :: Int -> [Formula]
qf_formula_intrels k = if k < 3 then [] else
                          let foldfunc = (\i lst -> lstunion lst [IntRel rel it1 it2 | rel <- intrels, it1 <- (inttermslist ! i), it2 <- (inttermslist ! (k-1-i))]) in
                            foldr foldfunc [] [1..(k-2)]
                                where
                                inttermslist = qf_formula_intterms (k-2)


-- All quantifier-free formulae below a certain cost
qf_formula :: Int -> [Formula]
qf_formula measure = dparray ! measure
    where
    lazycomp 0 = [Top,Bot]
    lazycomp k = let negforms = [Not f | f <- dparray ! (k -1)] in
             let conjforms = foldr (\i lst -> lstunion lst [And f1 f2 | f1 <- (dparray ! i), f2 <- (dparray ! (k-1-i))]) [] [0..(k-2)] in
             let disjforms = foldr (\i lst -> lstunion lst [Or f1 f2 | f1 <- (dparray ! i), f2 <- (dparray ! (k-1-i))]) [] [0..(k-2)] in
             let implforms = foldr (\i lst -> lstunion lst [Implies f1 f2 | f1 <- (dparray ! i), f2 <- (dparray ! (k-1-i))]) [] [0..(k-2)] in
             let labrelforms = qf_formula_labrels k in
             let intrelforms = qf_formula_intrels k in
               negforms ++ conjforms ++ disjforms ++ implforms ++ labrelforms ++ intrelforms
    valarray = Array.listArray (0,measure) [lazycomp cost | cost <- [0..measure] ]
    dparray = Array.listArray (0,measure) [(foldr (\e lst -> lstunion lst (valarray ! e)) [] [0..cost]) | cost <- [0..measure] ]

------------------------------------------------------------------------------------------------------
{- We can now synthesise quantified formulas of a certain number of variables and a certain cost by
using the above procedure for quantifier-free formulas and choosing to put various orders of quantifiers
on the variables (whose names we know because we created them).
-}


----------------------------------------------------------------------------------------------------

{-
This part of the file describes the semantics of formulae by evaluating them with respect to a model.
The model is stored as a list of pairs, the first component being the name of the relation, and the
second component a list of all tuples that the relation makes true. Functions are stored similarly,
with inputs and outputs being the tuples.
However, for relations and functions such as equality, integer comparison, etc., the functions are
implemented directly in the semantics.
-}