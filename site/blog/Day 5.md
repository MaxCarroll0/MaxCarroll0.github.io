<post-metadata>
  <post-title>Day 3</post-title>
  <post-series>I'm Attending ICFP & SPLASH 2025!</post-series>
  <post-date>2025-10-16</post-date>
  <post-tags> Talk, Conference, ICFP, HATRA, Programming Languages</post-tags>
</post-metadata>

Had a rest yesterday to see a bit of Singapore since there weren't many talks I wanted to go to. I find the [OOPSLA](https://2025.splashcon.org/track/OOPSLA?) lightning talks a bit chaotic to understand them easily. But today we have two talks on [bidirectional typing]() in a row, plus a talk on modules and one on pattern matching in the [ML family workshop](). These are probably my favourite areas of Programming language design!

# Freezing bidirectional typing
The first talk was to do with combining the two modalities of bidirectional typing: when typing information flows from the functions to the arguments and vice versa. This is something I'd never considered before and seems like it might be useful for performing more implicit forms of inference. The core idea was to bidirectjonally pass type ‘skeletons’ (like types but with unknown parts, which might be polymorphic), but there were major issues with inconsistencies between using different modalities (as in, sourcing the types from args might work while from the function might not) which was fixed with the idea of ‘freezing' which went a bit over my head.

However, it looks like these ideas could be of great inspiration for my future work with type slicing in the presence of more globsl bidirectional type inference. Similarly, the idea of type skeletons could give some interesting different perspectives on how we could treat the unknown type in Hazel (these seem to be like type skeletons, where the frozen parts are the non-unknown parts). I'm definitely going to look into this paper in great depth.

## Incremental Bidirectional Typing
Another Hazel distinguished paper by [Thomas]() and he did well to get across the ideas and background within the 15m talk! 
Back when I was working on my dissertation I was having similar ideas to incrementalise the Hazel bidirectional type checker as my type slicing calculations were appearing very slow in a live editing environment where the typed AST was being recalculated upon every update, even updates that are inconsequential to the types of the majority of the program. Turns out the Michigan team was already working on that...
The solutions they came up with to deal with non-local type propagation were quite interesting, as were the additional complexity of considering collaborative (distributed) edits, which with the new system can now be performed in any order (a CRDT) and can even be performed concurrently. You don’t even need to wait for the last edit to complete and type check before you make another one!
I really feel like Hazel is shaping up to be a great collaborative programming and editor experience, as they arrive to in their [vision paper]().

## Implicit Modules
Modular Implicits have been on the Ocaml horizon for years now, and yet there’s been no real progress. It’s great to see some revival of the ideas and I really hope we can get an implementation at some point. How can we still not have ad-hoc polymorphism in Ocaml!

Give short brief explanation of how it all works.

This is yet another case where I'm wanting to learn Scala to see how they do their implicit arguments.

## Pattern Matching
Improving pattern matching is something I've thought about extensively, and am surprised that Ocaml lacks some of the established ideas like Haskell's Views and F#'s Active Patterns. But this seems to be a common research direction as we’ve also had work by Lionel Parreaux on this in the last couple of years among others. For context I will explain Active Patterns:

This talk suggested an extension to pattern guards to directly allow nested matching of the bindings from the guarded pattern. For example, we can simplify the following nested match:
Etc etc
Then this naturally expands to allow the guards to form full boolean patterns (AND, OR, NOT), demonstrated below:
Etc etc
Then they allow smart constructors as a way of running arbitrary code . This can replicate the behaviour of Views and Active Patterns
Tese are all ideas I’ve been exploring myself independently, besides smart constructors (where I have just been thinking of using actuve patterns directly). In particular, trying to create a translation from this directly into nested match statements in Ocaml such that the feature could be used as a PPX rewriter in Ocaml directly. I don’t have time to do this myself at the moment but I think it’s a great way of extending pattern matching.
For further thought, other pattern matching ideas I’ve been mulling over include (DISCUSS them, butbwith no solutions, just the problems to solve):
Non-linear patterns – where the same variable may appear more than knce in a pattern requiring binding the same vslue. Especially in the presence of quotient types where there is a distinguished notion of equality
Backtracking patterns – like in Prolog
Inequalities in guards – with SMT based exhaustivity checking. Similarly for set membership and list lengths
Matching on Sets, Graphs
Active Patterns with custom defined or inferred exhaustivity rules
## Thoughts
A lot of interesting ideas today to unpack and see if I can incorporate them into my work. 
Went out for a curry in Little India with some of the Cambridge [EEG]() lot, I think I’ve now had more Indian food in my time in South East Asia than I have any individual South East Asian country's food. Was nice seeing the Diwali lights up in Little India.

