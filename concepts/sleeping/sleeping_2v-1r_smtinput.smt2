;Datatype of images
(declare-datatypes () ((Img
 s3 s2 s1 t2 t3 t1 s4
)))
;Constant symbols for objects
;All values are distinct by default
(declare-datatypes () ((Obj
 s3_o1 s3_o2
 s2_o2 s2_o3 s2_o1 s2_o4
 s1_o2 s1_o1
 t2_o5 t2_o4 t2_o7 t2_o6 t2_o1 t2_o3 t2_o2 t2_o9 t2_o8 t2_o10
 t3_o2 t3_o1
 t1_o1 t1_o2
 s4_o1
;extraneous objects
 nullobj bicycle person pottedplant bench cat
)))
;Membership of objects in images
;Extraneous objects belong to no images
(define-fun inImg ((x Obj )(y Img)) Bool
(or
(and (= x s3_o1) (= y s3))
(and (= x s3_o2) (= y s3))
(and (= x s2_o2) (= y s2))
(and (= x s2_o3) (= y s2))
(and (= x s2_o1) (= y s2))
(and (= x s2_o4) (= y s2))
(and (= x s1_o2) (= y s1))
(and (= x s1_o1) (= y s1))
(and (= x t2_o5) (= y t2))
(and (= x t2_o4) (= y t2))
(and (= x t2_o7) (= y t2))
(and (= x t2_o6) (= y t2))
(and (= x t2_o1) (= y t2))
(and (= x t2_o3) (= y t2))
(and (= x t2_o2) (= y t2))
(and (= x t2_o9) (= y t2))
(and (= x t2_o8) (= y t2))
(and (= x t2_o10) (= y t2))
(and (= x t3_o2) (= y t3))
(and (= x t3_o1) (= y t3))
(and (= x t1_o1) (= y t1))
(and (= x t1_o2) (= y t1))
(and (= x s4_o1) (= y s4))
))
;Machinery for looking up labels of objects
;Default value is 'nullobj'
(define-fun label ((x Obj)) Obj
(ite (= x t2_o10) person
(ite (= x s2_o4) person
(ite (= x s2_o1) bench
(ite (= x s2_o3) bench
(ite (= x s2_o2) bench
(ite (= x s3_o2) person
(ite (= x s3_o1) bench
(ite (= x t1_o2) person
(ite (= x t1_o1) bench
(ite (= x t3_o1) bench
(ite (= x t3_o2) person
(ite (= x s1_o1) cat
(ite (= x s1_o2) bench
(ite (= x s4_o1) bench
(ite (= x t2_o8) person
(ite (= x t2_o9) person
(ite (= x t2_o2) bench
(ite (= x t2_o3) bicycle
(ite (= x t2_o1) pottedplant
(ite (= x t2_o6) person
(ite (= x t2_o7) person
(ite (= x t2_o4) person
(ite (= x t2_o5) person
nullobj)))))))))))))))))))))))
)
;Datatype of relations--made into a uniform arity
(declare-datatypes () ((Rels neq labelOf sameLabel toLeft toRight above below within)))
;Relation evaluator
;All relations are made into a uniform arity using 'nullobj' as a default argument
(define-fun re ((r Rels)(a Obj)(b Obj)) Bool
(or
(and (= r neq) (not (= b a)))
(and (= r labelOf) (= b (label a)))
(and (= r sameLabel) (= (label b) (label a)))
(and (= r toLeft) (= a t2_o5) (= b t2_o4))
(and (= r toLeft) (= a t2_o5) (= b t2_o6))
(and (= r toLeft) (= a t2_o5) (= b t2_o1))
(and (= r toLeft) (= a t2_o5) (= b t2_o3))
(and (= r toLeft) (= a t2_o5) (= b t2_o9))
(and (= r toLeft) (= a t2_o5) (= b t2_o10))
(and (= r toLeft) (= a t2_o4) (= b t2_o6))
(and (= r toLeft) (= a t2_o4) (= b t2_o3))
(and (= r toLeft) (= a t2_o4) (= b t2_o9))
(and (= r toLeft) (= a t2_o7) (= b t2_o5))
(and (= r toLeft) (= a t2_o7) (= b t2_o4))
(and (= r toLeft) (= a t2_o7) (= b t2_o6))
(and (= r toLeft) (= a t2_o7) (= b t2_o1))
(and (= r toLeft) (= a t2_o7) (= b t2_o3))
(and (= r toLeft) (= a t2_o7) (= b t2_o2))
(and (= r toLeft) (= a t2_o7) (= b t2_o9))
(and (= r toLeft) (= a t2_o7) (= b t2_o8))
(and (= r toLeft) (= a t2_o7) (= b t2_o10))
(and (= r toLeft) (= a t2_o1) (= b t2_o6))
(and (= r toLeft) (= a t2_o1) (= b t2_o3))
(and (= r toLeft) (= a t2_o1) (= b t2_o9))
(and (= r toLeft) (= a t2_o8) (= b t2_o6))
(and (= r toLeft) (= a t2_o8) (= b t2_o3))
(and (= r toLeft) (= a t2_o8) (= b t2_o9))
(and (= r toLeft) (= a t2_o10) (= b t2_o6))
(and (= r toLeft) (= a t2_o10) (= b t2_o3))
(and (= r toLeft) (= a t2_o10) (= b t2_o9))

(and (= r toRight) (= a t2_o5) (= b t2_o7))
(and (= r toRight) (= a t2_o4) (= b t2_o5))
(and (= r toRight) (= a t2_o4) (= b t2_o7))
(and (= r toRight) (= a t2_o6) (= b t2_o5))
(and (= r toRight) (= a t2_o6) (= b t2_o4))
(and (= r toRight) (= a t2_o6) (= b t2_o7))
(and (= r toRight) (= a t2_o6) (= b t2_o1))
(and (= r toRight) (= a t2_o6) (= b t2_o8))
(and (= r toRight) (= a t2_o6) (= b t2_o10))
(and (= r toRight) (= a t2_o1) (= b t2_o5))
(and (= r toRight) (= a t2_o1) (= b t2_o7))
(and (= r toRight) (= a t2_o3) (= b t2_o5))
(and (= r toRight) (= a t2_o3) (= b t2_o4))
(and (= r toRight) (= a t2_o3) (= b t2_o7))
(and (= r toRight) (= a t2_o3) (= b t2_o1))
(and (= r toRight) (= a t2_o3) (= b t2_o8))
(and (= r toRight) (= a t2_o3) (= b t2_o10))
(and (= r toRight) (= a t2_o2) (= b t2_o7))
(and (= r toRight) (= a t2_o9) (= b t2_o5))
(and (= r toRight) (= a t2_o9) (= b t2_o4))
(and (= r toRight) (= a t2_o9) (= b t2_o7))
(and (= r toRight) (= a t2_o9) (= b t2_o1))
(and (= r toRight) (= a t2_o9) (= b t2_o8))
(and (= r toRight) (= a t2_o9) (= b t2_o10))
(and (= r toRight) (= a t2_o8) (= b t2_o7))
(and (= r toRight) (= a t2_o10) (= b t2_o5))
(and (= r toRight) (= a t2_o10) (= b t2_o7))

(and (= r above) (= a s2_o3) (= b s2_o1))
(and (= r above) (= a s2_o4) (= b s2_o1))
(and (= r above) (= a t2_o5) (= b t2_o2))
(and (= r above) (= a t2_o5) (= b t2_o8))
(and (= r above) (= a t2_o4) (= b t2_o2))
(and (= r above) (= a t2_o4) (= b t2_o8))
(and (= r above) (= a t2_o7) (= b t2_o2))
(and (= r above) (= a t2_o7) (= b t2_o8))
(and (= r above) (= a t2_o6) (= b t2_o2))
(and (= r above) (= a t2_o6) (= b t2_o8))
(and (= r above) (= a t2_o1) (= b t2_o2))
(and (= r above) (= a t2_o1) (= b t2_o8))
(and (= r above) (= a t2_o10) (= b t2_o3))
(and (= r above) (= a t2_o10) (= b t2_o2))
(and (= r above) (= a t2_o10) (= b t2_o8))

(and (= r below) (= a s2_o1) (= b s2_o3))
(and (= r below) (= a s2_o1) (= b s2_o4))
(and (= r below) (= a t2_o3) (= b t2_o10))
(and (= r below) (= a t2_o2) (= b t2_o5))
(and (= r below) (= a t2_o2) (= b t2_o4))
(and (= r below) (= a t2_o2) (= b t2_o7))
(and (= r below) (= a t2_o2) (= b t2_o6))
(and (= r below) (= a t2_o2) (= b t2_o1))
(and (= r below) (= a t2_o2) (= b t2_o10))
(and (= r below) (= a t2_o8) (= b t2_o5))
(and (= r below) (= a t2_o8) (= b t2_o4))
(and (= r below) (= a t2_o8) (= b t2_o7))
(and (= r below) (= a t2_o8) (= b t2_o6))
(and (= r below) (= a t2_o8) (= b t2_o1))
(and (= r below) (= a t2_o8) (= b t2_o10))

(and (= r within) (= a s2_o4) (= b s2_o2))
(and (= r within) (= a s1_o1) (= b s1_o2))
(and (= r within) (= a t2_o8) (= b t2_o2))
(and (= r within) (= a t3_o2) (= b t3_o1))
(and (= r within) (= a t1_o2) (= b t1_o1))

))
;Datatype for indicating which quantifier to use in formula
(declare-datatypes () ((Quantifier all one)))
;Datatype of indirections to indicate what the arguments of relations in the abstract baseformula are-- i.e, a datatype of bindings 
;Constants/extraneous objects have bindings as well
(declare-datatypes () ((Binding
 bind_x1 bind_x2
;bindings for extraneous objects
 bind_nullobj bind_bicycle bind_person bind_pottedplant bind_bench bind_cat
)))
;Defines how bindings correspond to valuations
;Default lookup is nullobj, but it is used since the function is defined for all bindings
(define-fun bindlook ((x1 Obj)(x2 Obj)(bind Binding)) Obj
(ite (= bind bind_x2) x2
(ite (= bind bind_x1) x1
;Bindings for extraneous objects
(ite (= bind bind_cat) cat
(ite (= bind bind_bench) bench
(ite (= bind bind_pottedplant) pottedplant
(ite (= bind bind_person) person
(ite (= bind bind_bicycle) bicycle
(ite (= bind bind_nullobj) nullobj
 nullobj))))))))
)
;Defines symbols used to indicate which boolean operators will be used, including negations, and their meanings as well
(declare-datatypes () ((Ops opand opor opimpl)))
(declare-datatypes () ((IfNeg yes no)))
(define-fun opeval ((op Ops) (arg1 Bool) (arg2 Bool)) Bool
 (ite (= op opand) (and arg1 arg2)
 (ite (= op opor) (or arg1 arg2)
  (=> arg1 arg2)
)))
(define-fun negeval ((val IfNeg)(arg Bool)) Bool
 (ite (= val yes)
  (not arg)
  arg
))
(declare-const q1 Quantifier)
(declare-const q2 Quantifier)


(declare-const n1 IfNeg)

(declare-const r1 Rels)

(declare-const arg1_1 Binding)
(declare-const arg1_2 Binding)

;Defines the innermost (quantifier-free) formula
(define-fun baseformula ((x1 Obj)(x2 Obj)) Bool
(negeval n1 (re r1 (bindlook x1 x2 arg1_1) (bindlook x1 x2 arg1_2)))
)
;Formula at quantifier level 2
(define-fun formula_level_2 ((x1 Obj) (img Img)) Bool
(ite (= q2 all)
 (forall ((x2 Obj)) (=> (inImg x2 img) (baseformula x1 x2)))
 (exists ((x2 Obj)) (and (inImg x2 img) (baseformula x1 x2)))
));Formula at quantifier level 1
(define-fun formula_level_1 ((img Img)) Bool
(ite (= q1 all)
 (forall ((x1 Obj)) (=> (inImg x1 img) (formula_level_2 x1 img)))
 (exists ((x1 Obj)) (and (inImg x1 img) (formula_level_2 x1 img)))
))

(assert (formula_level_1 t2))
(assert (formula_level_1 t3))
(assert (formula_level_1 t1))

(push)
(echo "Results for s3")
(assert (formula_level_1 s3))
(assert (not (formula_level_1 s2)))
(assert (not (formula_level_1 s1)))
(assert (not (formula_level_1 s4)))
(check-sat)
(get-model)
(pop)

(push)
(echo "Results for s2")
(assert (formula_level_1 s2))
(assert (not (formula_level_1 s3)))
(assert (not (formula_level_1 s1)))
(assert (not (formula_level_1 s4)))
(check-sat)
(get-model)
(pop)

(push)
(echo "Results for s1")
(assert (formula_level_1 s1))
(assert (not (formula_level_1 s3)))
(assert (not (formula_level_1 s2)))
(assert (not (formula_level_1 s4)))
(check-sat)
(get-model)
(pop)

(push)
(echo "Results for s4")
(assert (formula_level_1 s4))
(assert (not (formula_level_1 s3)))
(assert (not (formula_level_1 s2)))
(assert (not (formula_level_1 s1)))
(check-sat)
(get-model)
(pop)
