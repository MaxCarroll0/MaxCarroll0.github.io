<post-metadata>
  <post-title>Day 1</post-title>
  <post-series>I'm Attending ICFP & SPLASH 2025!</post-series>
  <post-date>2025-10-12</post-date>
  <post-tags>OxCaml, Effect Handlers, Substructural Type Systems, Relevant Type Systems, Erland, Conference, HOPE, TyDe Programming Languages</post-tags>
</post-metadata>

Off to a good start by getting ill on the first day of ICFP/SPLASH... Watched the first few talks online, but was able to make it in for the afternoon OxCaml talks.

## [HOPE](https://conf.researchr.org/home/icfp-splash-2025/hope-2025) [Smart Handlers: Handling the Selection Monad](https://conf.researchr.org/details/icfp-splash-2025/hope-2025-papers/7/Smart-Handlers-Handling-the-selection-monad)
There's been a flurry of effect handler related reseaech in the last few years, and here we have some more at the [HOPE](https://conf.researchr.org/home/icfp-splash-2025/hope-2025) _(Higher-Order Programming with Effects)_ workshop to start off the first day. 

This was a well-presented talk on creating a new type of effect handler that additionally has a notion of 'cost', calculated via a continuation logging a real number cost<fn>I would guess also likely to extend to all monoids admitting a total order. A monoid is required to accumulate costs, and some form of order is useful for applications to optimisation problems.</fn> alongside computation. So, we now get two continuations in the effect handler, as usual one for the remaining computation, but a second for leveraging the _future_ cost. Then, in the code, cost is defined by a primitive function and may be placed after the optimisation operations; all future costs are summed together (like in the Writer monad).

This allows for a modular way to abstract the solving of (possibly effectful) optimisation problems, greedy algorithms, and more by abstracting away how the loss is actually handled (e.g. if it is minimised or maximised and how, for example exhaustive search vs gradient descent) and allowing future cost to be taken account of. 

Here is an example of performing a basic linear least squares regression (in pseudo-OCaml syntax). We take the current slope (weight) <code>w</code> and offset (bias) <code>b</code> and simply call the effect <code>optimise</code> to retrieve the next parameters. Then, the loss is defined as the square of the difference between the target value (data-point) and the <code>y</code>-value of the line at <code>x</code> using the _new parameters_ (in the future). Notice also how the way that optimise actually uses the future loss to update parameters is abstracted completely from the function, and does not even need to be passed via any arguments, we just take the current parameters and the data.
<div class="language-ocaml">
let linear_reg (w, b) x target =
  let (w', b') = perform Optimise (w, b) in
  let y = (w' *. x) +. b' in
  let l = loss ((target -. y) *. (target -. y)) in
  (w', b')
</div>
For the handler we add a loss continuation <code>loss</code> to pseudo-OCaml alongside the normal continuation <code>k</code>. Then the code can use (possibly multiple times) the loss continuation to calculate losses based on various different choices of new parameters. For example, the below code performs auto-differentiation on the loss function with respect to the original parameters <code>(w, b)</code>.<fn>This will call the loss function only once, but other methods like numerical differentiation might use this multiple times with (ideally) converging parameters.</fn>. Finally, we nudge the parameters in the opposite direction of the gradients (gradient descent) with a scaling (learning rate) of <code>0.01</code>.
<div class="language-ocaml">
effect Optimize : float * float -> float * float

let h_opt f =
  try f () with
  | effect (Optimize (w, b)) loss k ->
    let (wd, bd) = autodiff loss (w, b) in
    let updated = (w -. 0.01 *. wd, b -. 0.01 *. wb) in
    continue k updated
</div>

To perform the training over the whole data we just need to fold the linear_regression in it's handler:<fn>The paper has some small complications to do with reseting the loss between iterations which I omit for clarity.</fn>
<div class="language-ocaml">
let train initial_params training_data =
  List.fold_left
    (fun params (x, y) ->
       h_opt (fun () ->
         linear_reg params x y))
    initial_params
    training_data
</div>

Of particular note is how operations and loss continuations can be combined to very easily abstract away _hyperparameters_ in machine learning. For example,  the learning rate hyperparameter can be set by an operation, which even allows it to make use of future loss to inform it's decision. For example, below we abstract the learning factor to an effect which then makes use of the loss continuation to try two learning rates and pick the one which minimised the loss.<fn>There was a good observation made by someone after the talk that effects performed within the loss continuation would be duplicated in such a situation which may (or may not) be undersirable.</fn> After choosing the learning rate you can use the original handler and fold to perform training. So in a sense, it performs some local pretraining to try and _tune_ the learning rate hyperparameter. This allows various forms of [hypermarameter tuning](https://en.wikipedia.org/wiki/Hyperparameter_optimization) to be abstracted easily and concisely.

<div class="language-ocaml">
effect LR : () -> float (* Get learning rate *)
effect Optimize : float * float -> float * float (* Get next parameters *)

(* Handler to perform optimisation *)
let h_opt f =
  try f () with
  | effect (Optimize (w, b)) loss k ->
    let (wd, bd) = autodiff loss (w, b) in
    let learning_rate = perform LR () in
    let updated = (w -. 0.01 *. wd, b -. 0.01 *. wb) in
    continue k updated

(* Handler to choose learning rate *)
let h_lr f =
  try f () with
  | effect (LR ()) loss k ->
    let lr1 = loss 0.01 in (* Try 0.01 learning rate *)
    let lr2 = loss 0.05 in (* Try 0.05 learning rate *)
    if lr1 < l2 then return 0.01 else return 0.05
</div>

From what I'm seeing this would absolutely be a brilliant tool for use in AI, Machine Learning, and Data Science. It'll be interesting to see if they can create a translation from this to standard effect handlers.

They derive a sound operational semantics for this, for which a key part involves use of the selection monad to reason about loss continuations. But, usage of the features doesn't need this so I will just show a few examples below of solving optimisation problems using this features, while abstracting away the details of the numerical methods. The full paper is available [here](https://doi.org/10.1145/3729321) for those curious.


## [HOPE](https://conf.researchr.org/home/icfp-splash-2025/hope-2025) [Finite functional programming via graded effects and relevance types](https://conf.researchr.org/details/icfp-splash-2025/hope-2025-papers/3/Finite-functional-programming-via-graded-effects-and-relevance-types):

This was supposedly an unrehearsed talk using handwritten slides, but was still very easy to follow, and probably the most enjoyable talk of the day. 
A type system for a _finite_ relational functional language for databases is defined, with the idea being that unlike with functions, we can be sure that queries on finite functions are terminating and fast.

Essentially it is based around _finitely supported_ functions, those which have a finite number of non-default values (this means that the domain need not be finite) i.e. finite tables. So, as we have default values it means we are actually working with [pointed sets](https://en.wikipedia.org/wiki/Pointed_set), rather than sets. Using pointed functions allows definitions to be extended (define a value which was previously default/nil) without having to extend the domain. It also allows easy types to be defined for AND operations via the [smash product](https://en.wikipedia.org/wiki/Smash_product) on pointed sets as if either element in the smash product is nil then the result is nil (i.e. an AND operation). Interesting because we had an exam question on smash products a few months ago and I thought it was just a made up thing, but it seems to actually be useful!!

What's interesting about this is we have that composition of definitely supported functions preserves finite supportedness. But it does NOT in general have an identity, as the identity function on an infinite domain, is not definitely supported (all outputs besides one are not nil). This is in contrast to just regular pointed functions on pointed sets, which do have identity and therefore form a valid category.

So this gives an interesting foundation to work with. And we are able to define various of the usual function primitives using the new **3** types of _functions_, _pointed functions_, or _finitely supported functions_. For example from any equality function we may create a finitely supported map which is non-nil for exactly one element (that it is equal to).<fn>Obviously this argument fails if we allow things like equivalence classes / quotients.</fn> Similarly, from a two values <span class="inline-math">x</span> and <span class="inline-math">y</span> a single finitely supported map can be defined mapping <span class="inline-math">x \mapsto y</span>. Various common querying functions are efficiently implementable on finitely supported maps: e.g. <code>exists</code>, <code>all</code>. 

Now whats super interesting is how to type check to ensure pointed functions and finitely supported functions are used correctly. For pointed functions one overapproximation we can do is try _relevant typing_<fn>This is super uncommon vs linear and affine typing!!</fn>, where we must use the bound variable _at least once_. This guarantees that a function is pointed, as all constructs we may use involving bound variable <span class="inline-math">x</span> are also pointed functions / relations meaning they will return nil if any argument is nil (which it must be as <span class="inline-math">x</span> must be one of the arguments). This is besides the nil function which is pointed (but does not mention <span class="inline-math">x</span>). There is one other case, the nil function is pointed but does not use it's bound variable, which we can allow. 

Overall, lots of interesting ideas, but much more work to be done to prove the results and actually have ways to easily construct finitely supported maps. I'm definitely interested in exploring some of these ideas myself.

TODO: Clean up from here & upload rest of blog
## Erlang Unions
I haven't really worked with unions, so watching this short lightning talk showed some very interesting examples and difficulties in it's type checking and inference. Didn't realise how unusual untagged unions are. Here is one example presented:

 Definitely something I want to explore more.

## OxCaml
Here we have more of a [tutorial]() on using the new OCaml system from [Jane Street](). [Oxidised OCaml]() adds 'modes' to OCaml, a new form of annotation generality orthogonal to types, allowing reasoning about memory locality and data races. I guess the name comes from the fact that it aims to allow more precuse memory management and safety like in [Rust](), and rust forms from oxidisation? Hope I'm remembering my GCSE Chemistry right... Also love that we now have a party of two animals (an Ox and a Camel) in the name; very creative.

I managed to make it in by lunch for this, and it was worth it. The tutorial was co-presented very well by my supervisor [Anil]() and [Gavin]() and encouraged interacting and discussing with the other attendees. Though, it was a bit quirky how he made us humm loudly to vote on questions, instead of just raising hands??

Actually demonstrating the benefits of this tool requires pretty solid knowledge of how the OCaml memory model works. They showed some great diagrams to get the points across even to those who haven't used OCaml much.

Sadly, this overlapped with [Patrick's]() (my other supervisor) talk about a [transpiler from OCaml -> Hazel]() which he created for me to amass a corpus of programs to use in evaluating my [dissertation](). I'm going to need to watch the recording for this; I still don't know how it works!!

## Thoughts
There were so many talks I had interest in thus day. While it was not the best having to watch half the day online, but I'm happy I made it in after lunch for OxCaml.

