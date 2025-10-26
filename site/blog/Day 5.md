<post-metadata>
  <post-title>Day 3</post-title>
  <post-series>I'm Attending ICFP & SPLASH 2025!</post-series>
  <post-date>2025-10-16</post-date>
  <post-tags> Bidirectional Type Systems, Hazel, Module Systems, Pattern Matching, Conference, OOPSLA, ML Family, Programming Languages</post-tags>
</post-metadata>

Had a rest yesterday to see a bit of Singapore since there weren't many talks I wanted to go to. I find the [OOPSLA](https://2025.splashcon.org/track/OOPSLA?) lightning talks a bit chaotic to understand them easily in only 15m. But today we have two talks on [bidirectional typing](https://doi.org/10.1145/3450952) in a row, plus a talk on modules and one on pattern matching in the [ML Family Workshop](https://conf.researchr.org/home/icfp-splash-2025/mlsymposium-2025). These are probably my favourite areas of Programming language design at the moment!

# [ML Family Workshop](https://conf.researchr.org/home/icfp-splash-2025/mlsymposium-2025): [Freezing Bidirectional Typing](https://conf.researchr.org/details/icfp-splash-2025/mlworkshop-2025/2/Freezing-Bidirectional-Typing-Extended-Abstract-)
The first talk was to do with combining the two modalities of bidirectional typing: when typing information flows from the functions to the arguments and vice versa. This is something I'd never considered before and seems like it might be useful for performing more implicit forms of inference. The core idea was to bidirectjonally pass type 'skeletons' (like types but with unknown parts, which might be polymorphic), but there were major issues with inconsistencies between using different modalities (as in, sourcing the types from args might work while from the function might not) which was fixed with the idea of 'freezing' which went a bit over my head.

However, it looks like these ideas could be of great inspiration for my future work with type slicing in the presence of more globsl bidirectional type inference. Similarly, the idea of type skeletons could give some interesting different perspectives on how we could treat the unknown type in Hazel (these seem to be like type skeletons, where the frozen parts are the non-unknown parts). I'm definitely going to look into this paper in great depth.

## [OOPSLA](https://2025.splashcon.org/track/OOPSLA?): [Incremental Bidirectional Typing](https://2025.splashcon.org/details/OOPSLA/138/Incremental-Bidirectional-Typing-via-Order-Maintenance)
Another Hazel distinguished paper by [Thomas](https://thomasporter522.github.io/) and he did well to get across the ideas and background within the 15m talk! 
Back when I was working on my dissertation I was having similar ideas to incrementalise the Hazel bidirectional type checker as my type slicing calculations were appearing very slow in a live editing environment where the typed AST was being recalculated upon every update, even updates that are inconsequential to the types of the majority of the program. Turns out the Michigan team was already working on that...

The solutions they came up with to deal with non-local type propagation were quite interesting, as were the additional complexity of considering collaborative (distributed) edits, which with the new system can now be performed in any order (a CRDT) and can even be performed concurrently. You don't even need to wait for the last edit to complete and type check before you make another one!

I really feel like Hazel is shaping up to be a great collaborative programming and editor experience, as they strive to in [one of their vision papers](https://hazel.org/papers/propl24.pdf).

## [ML Family Workshop](https://conf.researchr.org/home/icfp-splash-2025/mlsymposium-2025): [Implicit modules, a middle step towards modular implicits](https://conf.researchr.org/details/icfp-splash-2025/mlworkshop-2025/7/Implicit-modules-a-middle-step-towards-modular-implicits)
[Modular Implicits](https://doi.org/10.4204/EPTCS.198.2) have been on the Ocaml horizon for years now, and yet there's been little real progress since. It's great to see some revival of the ideas and I really hope we can get an implementation at some point. How can we still not have ad-hoc polymorphism in Ocaml!

Here's a possibly more digestible [blog post](https://tycon.github.io/modular-implicits.html) on them. They talked mainly about an intermediate system called 'module explicits' which is expected to be integrated to OCaml more easily.

This is yet another case where I'm wanting to learn Scala to see how they do their implicit arguments.

## [ML Family Workshop](https://conf.researchr.org/home/icfp-splash-2025/mlsymposium-2025): [A Core Language for Extended Pattern Matching and Binding Boolean Expressions](https://conf.researchr.org/details/icfp-splash-2025/mlworkshop-2025/5/A-Core-Language-for-Extended-Pattern-Matching-and-Binding-Boolean-Expressions)
Improving pattern matching is something I've thought about extensively, and am surprised that Ocaml lacks some of the established ideas like Haskell's Views and F#'s Active Patterns. This seems to be a common research direction recently as there's also had work by Lionel Parreaux on this in the last couple of years among others.

This talk suggested an extension to pattern guards to directly allow nested matching of the bindings from the guarded pattern. For example, we can simplify the following nested matches to perform nested bindings within the guards. Then this naturally expands to allow the guards to form full boolean patterns (AND, OR, NOT), demonstrated below. Then they allow smart constructors as a way of running arbitrary code as similarly to active patterns. All of the proposed features seemed very useful and not too difficult to implement.<fn>Though doing so efficiently might be more difficult.</fn>

These are all ideas I've been exploring myself independently, besides smart constructors (where I have just been thinking of using actuve patterns directly). In particular, trying to create a translation from this directly into nested match statements in Ocaml such that the feature could be used as a PPX rewriter in OCaml directly. I don't have time to do this myself at the moment but I think it's a great way of extending pattern matching.

For further thought, other pattern matching ideas I-ve been mulling over include:
- Non-linear patterns: Where the same variable may appear more than knce in a pattern requiring binding the same vslue. Especially in the presence of quotient types where there is a distinguished notion of equality.
- Backtracking patterns: like in Prolog
- Inequalities in guards: with SMT based exhaustivity checking. Similarly for set membership and list lengths 
- Matching on Sets & Graphs.
- Active Patterns with custom defined and inferred exhaustivity rules

I plan to write a longer post about some of these at some point in the future.

## Thoughts
A lot of interesting ideas today to unpack and see if I can incorporate them into my work. 
Went out for a curry in Little India with some of the Cambridge [EEG](https://www.cst.cam.ac.uk/research/eeg) lot, I think I've now had more Indian food in my time in South East Asia than I've had any individual South East Asian country's food. Was particularly nice seeing the Diwali lights up in Little India.

