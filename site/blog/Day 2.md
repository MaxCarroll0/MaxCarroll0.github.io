<post-metadata>
  <post-title>Day 2</post-title>
  <post-series>I'm Attending ICFP & SPLASH 2025!</post-series>
  <post-date>2025-10-13</post-date>
  <post-tags> Lenses, de Bruijn Indices, Codata, Copatterns, Conference, ICFP, Programming Languages</post-tags>
</post-metadata>

We now move over to Marina Bay Sands Conference Centre the for ICFP to start. Really fancy building with some amazing views. I'm looking forward to a few ICFP papers and also the 2nd [PROPL](https://propl.dev/) organised by Anil!

## [ICFP](https://icfp25.sigplan.org/): [Effectful Lenses](https://icfp25.sigplan.org/details/icfp-2025-papers/19/Effectful-Lenses-There-and-Back-with-Different-Monads)
I wasn't hugely familiar with lenses but it's something I've been wanting to look at. This was a very practical talk used a great running example which solves a problem I've thought about quite extensively before. The example was a _de Bruijn index_ converter, i.e. a system that converts between a named lambda representation and a nameless de Bruijn index representation, but also allows for edits (effects) in the named or nameless terms interleaved between convertions to and fro! 

Briefly, in most languages you _name_ the bindings introduced by functions (lambdas), e.g. <span class="inline-math">\lambda x.\ \lambda y.\ x + y</span> is a curried function adding its _named_ first and second arguments <span class="inline-math">x</span> and <span class="inline-math">y</span>. But named representations can be more difficult for compilers and proof systems to reason about becuase they must consider programs 'up to alpha equivalence', that functions which are the same up to just renaming the bound variables should be treated as equivalent, e.g. <span class="inline-math">\lambda a.\ \lambda b.\ a + b</span> should be an equivalent way to define addition function. A nameless encoding avoids this issue, for example de Bruijn indices represent variables by numbers which encoding the number of bindings at the point of the variable minus the number available where the variable was bound. For example, subscipting each lambda by its index, we get the addition function has exactly one de Bruijn nameless representation: <span class="inline-math">\lambda_{\color{green}\mathbb{0}}.\ \lambda_{\color{royalblue} \mathbb{1}}.\ {\color{green}\mathbb{0}} + {\color{royalblue}\mathbb{1}}</span>.

Then converting between these can be represented by a 'lens', which has two operations <code>view : named -> nameless</code> which 'views' the named term as its (unique) nameless term and <code>set : named -> nameless -> named</code> which takes both the original (in general, a 'template' to recover names from) named term and a nameless term to convert into named representation. In particular, effects must ensure the 'view-set' and 'set-view' properties hold,<fn>There is also a 'set-set' law, but it is relatively less relevant for this use case. So we only consider 'well-behaved' as opposed to 'very well-behaved' lenses (with set-set property) here.</fn> described in context:
- <code>view (set u t) = u</code> - converting a nameless term (<code>u</code>) to a named representation using some template (<code>t</code>), then viewing the named term as its nameless representation must recover the same original nameless term (<code>u</code>).
- <code>set (view n) n = n</code> - viewing a named term (<code>n</code>) as its nameless representation and then converting it back to a named representation with respect to the original term (i.e. using the original term as a template to retrieve the names) should return the original named term (<code>n</code>).

This can all be done with normal lenses, so why do we need effects? Well, compilers and the such would modify the unnamed representation during optimisation, but we may want to return back to a named representation to show the programmer, how can we represent this? We can consider various edits on the nameless (or named) terms to be _effects_. Then, we want the view-set and set-view properties to hold 'up to these effects' that is, we want to recover a named term (resp. nameless term) which would be produced by performing the _same edits_ to the original named (resp. nameless) program. i.e. see how the variable names are recovered even after edits below:
<div class="display-math">\begin{align*} n = &\lambda x.\ \lambda y.\ x + y\quad &\Rightarrow^{\texttt{view}}\quad \lambda_{\color{green}\mathbb{0}}.\ \lambda_{\color{royalblue} \mathbb{1}}.\ & {\color{green}\mathbb{0}} + {\color{royalblue}\mathbb{1}}\\ 
& & & \quad\vdots\\ 
& & & \textit{(edits)}\\ 
& & & \quad \vdots\\ 
&\lambda x.\ \lambda y.\ y + x\quad &\Leftarrow^{\texttt{set n}}\quad \lambda_{\color{green}\mathbb{0}}.\ \lambda_{\color{royalblue} \mathbb{1}}.\ & {\color{royalblue}\mathbb{1}} + {\color{green}\mathbb{0}} \end{align*}</div>

The way they formalise this is by allowing the user to define a 'round-trip relation' to define exactly how the equivalences (view-set and set-view laws) should behave in the presence of effects, which is then verified by its encoding in the type system. We obviously want the round-trip relation to ensure that we recover the names of all variables from the original program, but there is then a problem for edits which add an additional lambda expression, where we need to 'generate a new variable name'. Basically, the round-trip relation must make sure the name-index association is kept even after edits, and that new variables are named in a consistent manner (intuitively, so that we can 'replay' these edits in the named version to check equivalence). Three examples of naming new variables are given in the paper:
- Stateless: Deterministically picks a new name which does not already occur in scope. The same names would be generated in different scopes.
- Stateful: Deterministically picks a new name not in scope, but keeps track of all previously generated names. So, we never generate the same name twice within the same program (as might be confusing in the stateless representation).
- User Input: Non-deterministically pick new names from user input, as long as they not already in scope (giving an error effect otherwise, which is also accounted for in the relation).

Use of effects can even extend to other situations, like allowing conversion from named representations with unbound variables (which are erroneous and so have _no_ nameless representation) and back again using a different round-trip relation to define the equivalences here (i.e. if error occurs the original program should be recovered), similary IO can be modelled.

## [ICFP](https://icfp25.sigplan.org/): [First Order Laziness](https://icfp25.sigplan.org/details/icfp-2025-papers/26/First-Order-Laziness)
This was my favourite talk of the day, relating to purely functional infinite data structures, allowing easier pattern matching on lazy data structures within a _strict_ langauge.

Instead of having laziness in a strict language be represented by unit closures, which are annoying to pattern match upon, can be difficult to reason about (e.g. cannot be printed), and also inefficient, this talk proposes defining lazy constructors within the type and defining them by a function taking their data to a computation returning a value of the type. Crucially, a lazy constructor only reduces its arguments _once it is matched upon_ and _is a value_ (so does not need to be evaluated to store in constructors or pass to functions); this behaviour makes these constructors act _lazily_. 

See the lazy list definition below with two normal (non-lazy) constructors for consing an element to a stream and the empty stream (<code>Nil</code>). Then we have a lazy <code>Append</code> constructor and a lazy <code>Take</code> constructor:
<div class="language-ocaml">
type 'a stream =
  | Cons of 'a * 'a stream
  | Nil
and lazy Append of 'a stream * 'a stream = fun
  | (Cons (x, xs), _) -> Cons (x, Append (xs, s2))
  | (Nil, _) -> s2
</div>
Then, when writing a function on streams, we are only allowed to match upon the strict constructors, and any lazy constructors are evaluated with their corresponding function before being matched upon.

What is especially interesting about treating this first class is that you can define a 'lazy match' construct that actually doesn't reduce the term and lets you match on a lazy constructor, for example to print how a term is being lazily constructed. Of course, this is not referentially transparent as two terms of a lazy type which evaluate to the same value could make use of different lazy constructors and consequentially have differing behaviour under lazy matching.

### Codata
What's particularly interesting is the parallels to [codata](https://reasonablypolymorphic.com/blog/review-codata/) (the dual of data), which is another way of defining lazy data. With codata you define _destructors_ instead of constructors, i.e. how to use a value of a type, but not how to construct it. For example see lazy lists below, you can think of the destructors as functions _from_ streams to some type, i.e. <code>head : 'a stream -> 'a</code>: 
<div class="language-ocaml">
codata 'a stream =
  | Head of 'a
  | Tail of 'a stream
</div>

Then there is an idea called [copattern matching](https://reasonablypolymorphic.com/blog/review-copatterns/) which allows you to define functions on Codata via the denstructors, see append defined below:
<div class="language-ocaml">
Head (append s1 s2) = Head s1
Tail (append s1 s2) = append (Tail s1) s2
</div>
Or written in a more OCaml-like syntax we could have copatterns (and cofunctions) like:
<div class="language-ocaml">
append s1 s2 = cofun
  | Head -> Head s1
  | Tail -> append (Tail s1) s2
</div>

While the particular definitions differ quite a bit (they are sort of inverted<fn>Duality :)</fn>) the fact that we have a different form of constructor that is explicitly lazy, and first class, and has support for pattern matching, makes it an interesting candidate to solve the same problem as these first-class lazy constructors.

### Modularity & Open Types
One issue with this system is the lazy constructors are attached to the type. This is non-extensible if the type was provided by a library, meaning you effectively cannot define new lazy functions on the type.

Anton proposed two solutions which I think are both unsatisfactory: 
- Use of open data types (which has the consequence of making the strict constructor data open as well and therefore exhaustivity checks on the strict constructors).<fn>Although, I suppose a 'half-open' data type making only the lazy constructors open could work? But does just seem more complicated than my suggestions below.</fn>
- Exposing a force delay API (which would negate all the benefits of the method for newly defined functions...).

I had a talk with him afterwards to try get to the bottom of why exactly the lazy constructors have to be defined in the type, after all with Codata _this is not the case_ (see append being defined outside via copatterns). From what I was thinking, you could simply leave lazy constructors outside the type and link them in a similar way to functions, so when a match comes we look up the lazy constructor definition and apply it as normal, there is no need for it to be in the type. _Why does this work?_ Well because match statements must only refer to concrete constructors, any client code does not need to know about which or how the lazy constructors are defined ahead of time. It is still probably beneficial to have table lookups/pointers rather than treating them directly as functions for efficiency reasons.

Of course, this reasoning does _not_ apply to lazy matches, where we might now get an _inexhaustive match_ where code in the original library is unaware of lazy constructors defined outside it by the user. Exhaustivity could still be checked, but the library code cannot be changed to add the extra cases. We could allow functions to be extended outside of the library<fn>Like some sort of 'open functions' similar to 'open data types'</fn>, but this is still undesirable to the user in the general case. Given we have already made a compromise on referential transparency for lazy matches, I suggest a compromise to lazy matching to add an implicit wildcard case which reverts back to regular match. So, for any lazy constructors which are not cases of the particular lazy match, we just evaluate them to a strict constructor by using a regular match and re-run the lazy match with this reduced value which must handle the strict constructors (to pass exhaustivity checks).

See below the library code and user code, and how the library print function would still work, but just be unable to print the newer lazy constructor definition.:

<div class="language-ocaml">
(* Library Code : Stream.ml *)
type 'a stream =
  | ( :: ) of 'a * 'a stream
  | [] of 'a stream
and lazy Append of 'a stream * 'a stream = fun
  | (x :: xs, s2) -> x :: Append (xs, s2)
  | ([], s2) -> s2
  
let rec preview elem_to_string s = lazy match s with
  | [] -> "Empty stream"
  | x :: xs -> "Stream starting with " ^ elem_to_string x
  | Append(s1, s2) -> to_string s1 ^ " Appended to " ^ to_string s2
  (* Default case below: syntax sugar could omit *)
  | _ -> match s with s -> preview elem_to_string s
  
(* Client Code *)
open Stream
  
lazy Interleave of 'a stream * 'a stream = fun
  | (x :: xs, s2) -> x :: Interleave (s2, xs)
  | ([], s2) -> s2
  
(* Stream.to_string has no Interleave case *)
Interleave (1 :: 3 :: [], 2 :: 4 :: []) |> Stream.preview (Int.to_string) |> println
(* Prints: "Stream starting with 1" *)
(* As Interleave (...) evaluates to (value) x :: Interleave (s2, xs) 
                       which matches the 2nd line of preview*)
</div>

I'll discuss this with him later as I didn't really get much of a response after the talk on if these ideas are actually valid and effecient, as Lionel Parreaux was ranting about Scala being able to do all of this and that. Maybe I should look into Scala too, it seemed like it has lots of very interesting features.

## [Doctoral Symposium](https://2025.splashcon.org/track/splash-2025-Doctoral-Symposium): [Practical Compositional diagramming](https://2025.splashcon.org/details/splash-2025-Doctoral-Symposium/4/Practical-compositional-diagramming):
This was a report on an in-progress interesting PhD project which intersects with human computer interaction (just like my work does). The author has created various compositional diagramming tools for trees and railway diagrams, where you can compose smaller diagrams together in a predictable way, and where equivalent conceptual representations produce identical diagrams (up to page size constraints). Current diagramming tools are heavily dependent on the order of specifications, and may produce different diagrams for the same conceptual diagram if the information is presented in a different order.

Further another goal is 'continuity', that incremental changes to the specification for his tool should produce only small incremental changes to the output diagram (again, up to page constraints). However, I'm not really sure or if he has formalised what exactly these incremental changes even mean. His examples showed that it seemed to work well, but this certainly seems like a currently subjective argument that could be quantified or more formally defined in some way.

While this seemed very interesting and usable I'm still not sure how exactly the existing graphing tools are not compositional, and when exactly the are not continuous. It seems like current tools at least try to have these properties for a lot of cases? Then again, I've not used many diagramming tools extensively so maybe this is a big issue.

## Thoughts
Fewer talks I was interested in / able to follow today, but still some really good ones. First-class lazy constructors is definitely something I want to look into and try out; I've been thinking of writing a little programming language prototype with codata and copatterns to try those out too.

Still got a sore throat, let's hope it's better for my talk tomorrow...
