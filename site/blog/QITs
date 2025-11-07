<post-metadata>
  <post-title>Programming with Quotients</post-title>
  <post-date>2025-10-01</post-date>
  <post-tags>Quotient Inductive Types, Dependent Types, Invariants, Type Theory, Homotopy Type Theory</post-tags>
</post-metadata>

Type systems allow programmers to express the intent of their program, and catch errors which would violate their intent <fn>Strictly speaking, not arbitrary. We still cannot reason about effects directly and reasoning about these properties in the presence of non-termination is difficult.</fn> *statically*. In the simple case this amounts to checking that the inputs and outputs of functions are of the same `shape` — that is, integers or strings, or functions.

Dependent types take this further, allowing programmers to express arbitrary properties and invariants about their code, greatly extending their ability to (statically) ensure correctness of programs. Further, this allows users of the code to directly see these properties<fn>In essence, a form of automatically up-to-date and provable documentation.</fn>, provably confirm that invariants are preserved<fn>Again, up to non-termination.</fn>, and have the compiler check that their usage of the code still maintains these invariants.

Alongside this, dependent types are expressive, allowing programs that would be impossible to write in languages with weaker type systems (or would require explicit and less flexible extensions). For example, abstract types (via dependent pairs and existentials) (MacQueen 1986), type-indexed ASTs (such as GADTs), (impredicative) polymorphism (Girard 1986), heterogeneous lists, type reflection (Šinkarovs and Cockx 2021).

Here, I will talk about Quotient Inductive Types (QITs) and extend examples from systems programming (Brady 2011) and a classic merge sort implementation (McKinna 2006), exploring how they can concisely and intuitively describe and enforce equational program properties.

## Quotient Inductive Types

QITs extend inductive types by including *path constructors*<fn>This terminology comes from Homotopy Type Theory (Univalent Foundations Program 2013) where equality types are interpreted as paths in a topological space (where spaces represent types).</fn> which identify points (values) of the type with one another. Essentially, a path constructor adds an equational law to the type, extending its notion of equality. We implicitly take the reflexive, transitive, symmetric closure to make these laws an equivalence relation. Intuitively, a function from the quotient type is a function from the unquotiented type which respects the equivalence relation (the quotient, $(\sim)$) — i.e. for function \(f : Q \to T\) and equivalence \(\sim\) on \(Q\):

<div class="display-math">(\forall x : Q, y : Q.\ \ x \equiv_{\sim} y \implies f(x) \equiv_T f(y)) \implies f : Q / \sim\ \to T</div>

As quotients can be thought of as "adding structure" to free inductive types, it is desirable to allow structural subtyping and extension of existing types with path constructors ("quotienting" a type). One way of doing this would be like polymorphic variants in OCaml (Madhavapeddy, Minsky, and Hickey 2022).

### Rationals

We can represent fractions by a pair of an integer numerator and positive denominator. Then rationals can be the quotient of fractions equating all representations of the same rational:

<div class="language-idris">
data <span class="inline-math">\mathbb{Q}</span> : Type where
  _/_ : <span class="inline-math">\mathbb{Z}</span> -> <span class="inline-math">\mathbb{N^+}</span> -> <span class="inline-math">\mathbb{Q}</span>
  Eq : (n/m : <span class="inline-math">\mathbb{Q}</span>) -> (n'/m' : <span class="inline-math">\mathbb{Q}</span>) -> (n * m' = n' * m) 
        -> (n/m = n'/m')
</div>

Then to define a function \(f\) on this type we define it at the points as usual *and* the paths (equalities): \(ap_f\ (p : a = b) : f(p) = f(q)\). I have made up a notation where you pattern match each path constructor and overload function name `f`:

<div class="language-idris">
f : (p : x = y) -> f x = f y
f (PathConstr1(?fields) : x = y) = ?prove : f x = f y
f (PathConstr2(?fields) : x = y) = ?prove : f x = f y
</div>

For example, negation:<fn>You can really see the functorial/categorical foundations in these definitions.</fn>

<div class="language-idris">
-_ : <span class="inline-math">\mathbb{Q}</span> -> <span class="inline-math">\mathbb{Q}</span>
-(n/m) = (-n)/m
{- We must also provide a case for the path constructor -}
{- Remember (Eq q q' p) : q = q', so -(Eq q q' p) : -q = -q' -}
{- Remember that p : n * m' = n' * m -}
{- Assume a lemma that L {n,m} = (-n) * m = -(n * m) -}
-(Eq q q' p) = Eq (-q -q' (L >> -p >> L^{-1}))
</div>

Here `>>` represents path composition and `^{-1}` path inversion. I.e. for \(p : a = b\) and \(q : b = c\) then \(p \mathrel{>>} q : a = c\) and \(p^{-1} : b = a\). Applying a function \(f : A \to B\) to a path \(p : a =_A a'\) gives \(f(p) : f(a) =_B f(a')\); in the above case \(-p : -(n*m') = -(n'*m)\).

The ideas extend to multiple-argument functions:

<div class="language-idris">
_*_ : <span class="inline-math">\mathbb{Q}</span> -> <span class="inline-math">\mathbb{Q}</span> -> <span class="inline-math">\mathbb{Q}</span>
(n/m) * (n'/m') = (n * n')/(m * m')
{- Assume associativity lemma A {a,b,c} : (a*b)*c = a*(b*c) and commutativity lemma C {a,b} : a * b = b * c -}
{- This proof could be simplified via stronger lemmas -}
(Eq q r p) * (Eq q' r' p') =
  let rearrange = A >> (refl * A^{-1}) >> (refl * (C * refl)) 
                  >> (refl * A) >> A^{-1} in
  let e =  rearrange >> (p * p') >> rearrange in
  Eq ((q * q') (r * r') e)
</div>

### Unordered Pairs

Similarly, we can represent unordered pairs:

<div class="language-idris">
data UPair : Type -> Type -> Type where
  (,) : UPair a b
  Swap : ((x, y) : UPair a b) -> (x, y) = (y, x)
</div>

Whose functions `f : UPair a b -> T` must have a case, which amounts to proving commutativity!

<div class="language-idris">
f (Swap (x,y)) = ?commutativity : f (x, y) = f (y, x)
</div>

### Multisets

Now we get onto examples from some papers. In the motivation for Epigram (McKinna 2006) a merge sort is formalised. Their final sorting function has the following type:<fn>In Idris syntax.</fn>

<div class="language-idris">
data OList <span class="inline-math">\mathbb{N}</span> where
  [] : OList 0
  (::) : (x : <span class="inline-math">\mathbb{N}</span>) -> {y : <span class="inline-math">\mathbb{N}</span>} -> {auto lt : x <= y} 
         -> OList y -> OList x

sort : List <span class="inline-math">\mathbb{N}</span> -> OList 0
</div>

Where `OList` is a locally sorted list with an (open) lower bound on all its elements. The locally-sorted property is ensured by the requirement that to cons a list we must provide a proof `lt : x <= y`. However, this of course does not require the resulting list to have the same elements as before, just that it is sorted.<fn>Which they mention in the paper of course.</fn> We could just always return the empty list!

But how could this invariant be enforced? Well, there are many ways: you could explicitly include a permutation proof `Permutation : List \mathbb{N} -> List \mathbb{N} -> Type` on lists and a `toList` function from `OList 0` to `List \mathbb{N}`, require that `sort` also returns a proof:

<div class="language-idris">
sort : (xs : List <span class="inline-math">\mathbb{N}</span>) -> (ys : OList 0 ** Permutation(xs, toList ys))
</div>

We then have to pass and manipulate the proof explicitly through each recursive call of the sort function.

But, I found an interesting way to do this differently with quotients. We simply say that `sort` takes multisets (whose underlying inductive type is `List \mathbb{N}`) to sort. Then any lists that differ only by ordering are identified by the same multiset and must return equivalent `OList`s. However, there is still no link between the input and output, and it seems a dependent pair is unavoidable: here we require that the input multiset is equal to the output. That is, that `sort` is an identity function on multisets. What makes this method easier is that the quotients have already enforced that all permutations map to the same output; we should only need to prove the equality for the case when the input is already sorted!

The easiest way to define multisets is by asserting that if you union (append) two multisets in any order, then they are still equal. It is easy to see that this creates an equivalence relation relating all permutations together.

<div class="language-idris">
data Multiset : Type -> Type where
  List a {- extending lists with a quotient 
            (like in polymorphic variants) -}
  Commute : (xs : Multiset a) -> (ys : Multiset a) 
            -> xs ++ ys = ys ++ xs

sort : (xs : Multiset <span class="inline-math">\mathbb{N}</span>) -> (ys : OList 0 ** xs = ys)
</div>

By the subtyping ideas mentioned earlier, a list is automatically a multiset. Interestingly, we can use sorted lists as a canonical form for multisets, meaning any function `f : OList 0 -> T` precomposes with `sort` to give rise to a function out of the quotient `f ∘ sort : Multiset \mathbb{N} -> T` with *no proof obligations*. Equally, multisets could have been defined by quotienting with `sort` (i.e. identifying lists whose sorted representations are equal).

### Equational Algebras

Every inductive type generates a free algebra (Burris and Sankappanavar 1981), while quotients allow further non-trivial identifications between terms to be made. This allows us to impose an *equational theory* upon the inductive type.

For example, we can consider a Packet DSL implemented in Idris by Brady (2011). They start with a basic type to describe primitive data chunks of length-indexed bits, null-terminated strings, length-indexed strings, and propositions about the chunks:<fn>Just a question: why don't they also check that length-indexed strings are non-negative? Like they do with bit chunks?</fn>

<div class="language-idris">
data Chunk : Set where
  bit : (width: Int) -> so (width>0) -> Chunk
  | Cstring : Chunk
  | Lstring : Int -> Chunk
  | prop : (P:Prop) -> Chunk
</div>

Since these are purely markers, we cannot do any meaningful quotients here. However, the propositions with `and` and `or` constructors could be equated via de Morgan's laws.

More importantly, they define a `PacketLang` DSL, where we can add some useful equational laws:

<div class="language-idris">
data PacketLang : Set where
  CHUNK : (c:Chunk) -> PacketLang
  | IF : Bool -> PacketLang -> PacketLang -> PacketLang
  | (//) : PacketLang -> PacketLang -> PacketLang
  | LIST : PacketLang -> PacketLang
  | LISTN : (n:Nat) -> PacketLang -> PacketLang
  | BIND : (p:PacketLang) ->
           (mkTy p -> PacketLang) -> PacketLang
  {- Path Constructors -}
  | IFTrue : If true p q = p
  | IfFalse : If false p q = q
  | IfSame : {p = q} -> If b p q = p
  | OrAssoc : (p // q) // r = p // (q // r)
  | OrComm : p // q = q // r
  | OrSame : {p = q} -> p // q = p
  | BindRet : {p : PacketLang} -> {f : mkTy p -> PacketLang} 
              -> BIND (CHUNK x) f = f (mkTy x)
  | BindAssoc  : {p : PacketLang} {f : mkTy p -> PacketLang} 
               -> {g : mkTy (BIND p f) -> PacketLang} 
               -> BIND (BIND p f) g = BIND p (\x => BIND (f x) g)
  | ... {- etc. (note, not all the obvious laws work due to weirdness of mkTy) -}
</div>

However, since everything decodes via `mkTy` and `chunkTy` to (different, built-in) Idris types, we can only get isomorphisms, not equalities between these results, which is incompatible with our quotients that require equivalence. Although this would be fine in a homotopy setting by the Univalence axiom (Univalent Foundations Program 2013). Similarly, it would be nice to have laws saying that the equational theory is *algebraic* w.r.t. `BIND` (that `IF` and `//` distribute through `BIND`) but these do not type check. Creating a unified inductive data type instead of decoding various different generic Idris types, then `mkTy` would effectively be a normalisation (eval) function on the DSL, performed before marshalling in order to extract the data consistently without violating the quotients. In this situation, the type system would need to *normalise* the `PacketLang` terms before being passed into C code as the laws cannot be verified within C code.

Quotients can represent much more complex equational theories, as can be seen in Altenkirch and Kaposi (2016).

## Feasibility & Usability

I have demonstrated by example how quotients could be used to express equalities more concisely and automate their preservation. Without them, you end up having to remember yourself to prove that equalities are preserved and may only be able to do so less concisely or separately from the functions involved.

But, I skirted over important technical limitations. First, implementation of quotient inductive types is in its infancy: the only "real" implementations (i.e. not glorified setoids — though those examples can still reap many benefits) such as *Cubical Agda* (Vezzosi, Mörtberg, and Abel 2021) are based upon cubical type theory (Cohen et al. 2016) via higher-inductive types (see Benedikt Ahrens' HIT slides). There has historically been great difficulty implementing quotients due to their *extensional* nature, blurring propositional and judgemental equalities, resulting in issues with decidability and termination. Other attempts have been undertaken historically: for example, *Epigram 2* was intended to include observational type theory (Altenkirch, McBride, and Swierstra 2007) allowing a (restricted) sense of extensional equality, but was sadly abandoned — see Conor McBride’s [retrospective](https://www.youtube.com/watch?v=5vZJVWCgf_4).  

Second, we still need to perform proofs that quotients are respected, and proof automation for path constructors might have unique challenges compared to proof automation and related tools for dependent types and refinement types. There has been some work on proof automation for quotients (Hewer and Hutton 2024; Huffman and Kunčar 2013), but not that I know of in a path-constructor / homotopy setting. In particular, *Quotient Haskell* has considered more deeply the practicalities relating to syntax (quotienting existing types) and subtyping (types with a subset of the equational rules).

---

## References

- MacQueen, D. B. 1986. *Using dependent types to express modular structure*. POPL ’86. <https://doi.org/10.1145/512644.512670>  
- Girard, J.-Y. 1986. *The system F of variable types, fifteen years later*. Theoretical Computer Science. <https://www.sciencedirect.com/science/article/pii/0304397586900447>  
- Šinkarovs, A. and Cockx, J. 2021. *Extracting the power of dependent types*. GPCE 2021. <https://doi.org/10.1145/3486609.3487201>  
- Brady, E. C. 2011. *IDRIS — systems programming meets full dependent types*. PLPV ’11. <https://doi.org/10.1145/1929529.1929536>  
- McKinna, J. 2006. *Why dependent types matter*. SIGPLAN Not. / POPL ’06. <https://doi.org/10.1145/1111037.1111038>  
- Univalent Foundations Program. 2013. *Homotopy Type Theory: Univalent Foundations of Mathematics* (book). <https://homotopytypetheory.org/book>  
- Madhavapeddy, A., Minsky, Y., and Hickey, J. 2022. *Polymorphic Variants (Chapter 6.5)*. In *Real World OCaml* (online chapter). <https://dev.realworldocaml.org/variants.html\#polymorphic-variants>  
- Altenkirch, T. and Kaposi, A. 2016. *Type theory in type theory using quotient inductive types*. POPL ’16. <https://doi.org/10.1145/2837614.2837638>  
- Burris, S. N. and Sankappanavar, H. P. 1981. *Terms, Term Algebras, and Free Algebras*. In *A Course in Universal Algebra*.  
- Vezzosi, A., Mörtberg, A., and Abel, A. 2021. *Cubical Agda: A dependently typed programming language with univalence and higher inductive types*. J. Funct. Program. <https://doi.org/10.1017/S0956796821000034>  
- Cohen, C., Coquand, T., Huber, S., and Mörtberg, A. 2016. *Cubical Type Theory: a constructive interpretation of the univalence axiom*. arXiv preprint. <https://arxiv.org/abs/1611.02108>  
- Hewer, B. and Hutton, G. 2024. *Quotient Haskell: Lightweight Quotient Types for All*. Proc. ACM Program. Lang. (POPL). <https://doi.org/10.1145/3632869>  
- Huffman, B. and Kunčar, O. 2013. *Lifting and Transfer: A Modular Design for Quotients in Isabelle/HOL*. CPP 2013. <https://doi.org/10.1007/978-3-319-03545-1_9>  
- Altenkirch, T., McBride, C., and Swierstra, W. 2007. *Observational equality, now!*. PLPV ’07. <https://doi.org/10.1145/1292597.1292608>  
