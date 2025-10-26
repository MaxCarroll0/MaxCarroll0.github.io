<post-metadata>
  <post-title>Day 3</post-title>
  <post-series>I'm Attending ICFP & SPLASH 2025!</post-series>
  <post-date>2025-10-14</post-date>
  <post-tags> Type Slicing, Refinement Types, Syntax, Debugging, Docker, OCaml, Music, Hazel, Talk, Conference, ICFP, HATRA, Programming Languages</post-tags>
</post-metadata>

Today was the day of my talk, luckily it was quite early so I can get it over and done with. I had two great talks preceding mine to contend with which was a bit intimidating.

## [Hatra](https://conf.researchr.org/home/icfp-splash-2025/hatra-2025): [Usability Barriers for Liquid Types](https://conf.researchr.org/details/icfp-splash-2025/hatra-2025-papers/5/Usability-Barriers-for-Liquid-Types-Summary-of-Published-Work-)
The first HATRA talk was a report on a user study on the usability of liquid types ([LiquidHaskell](https://ucsd-progsys.github.io/liquidhaskell/)) for both _new_<fn>To LiquidHaskell, but knew Haskell well.</fn> and _experienced_ users. This was extremely well presented and very useful reference for me as I have never actually seen a user study report and have been planning to perform one on my research in collaboration with the [Future of Programming Lab](https://neurocy.notion.site/Future-of-Programming-Lab-241d162461a04064ae1fd9ae32bf4cb1) led by [Cyrus](https://web.eecs.umich.edu/~comar) at Michigan in the future.

The study itself concluded by identifying a few usability barriers for liquid (refinement) types evidenced by the qualitative and quantitative results gathered during the study on their 19 participants. The barriers identified were classified into three groups:
### Developer Experience
- Unhelpful error messages: A common experience in most statically typed languages, and even more so with complex and huge types as is often the case with refinement types. I'm very familiar with difficulties in type error messages, after all my talk will be on tools to help understand and explain types!
- Limited IDE support: LiquidHaskell is still relatively unused so has little IDE integration. Given how complicated the type system can get, better IDE support for understanding, exploring, and exploiting this should be a major focus.
- Insufficient learning resources and documentation: Again stemming from underuse.
- Complex installation and setup: One of the most obvious barriers to entry for many software tools. 

### Scalability Challenges
As in, issues with large codebases.
- Long lompilation time: Examples included compilation times of 5 hours. SMT solvers (likely)<fn>The [exponential time hypothesis](https://en.wikipedia.org/wiki/Exponential_time_hypothesis).</fn> have an unavoidable exponential time complexity.

### Verification Challenges
As liquid/refinement types attempt to automate as much proofs as possible it can make the divide between verification and the core language (Haskell) unclear and also obscure the proof system itself.
- Unclear divide between Haskell and LiquidHaskell
- Confusing verification features: Confusion with the difference between bound and unbound variables in type aliases. When do bound/unbound variables get generalised via a forall quantifier?
- Unfamiliarity with proof engineering: Verification may fail depending on the particular pre and post conditions used. Understanding why in order to pick the right conditions requires understanding of the verification system and by extension proof engineering.
- Limitations of automated theorem proving and integration of manual proofs: SMT solvers can't solve everything. Integration with manual proofs when the programmer knows how to prove something that the compiler doesn't is difficult.

## [HATRA](https://conf.researchr.org/home/icfp-splash-2025/hatra-2025): [Imperative Syntax for Dependent Types](https://conf.researchr.org/details/icfp-splash-2025/hatra-2025-papers/7/Imperative-Syntax-for-Dependent-Types)
Another well presented talk with great slides (manually syntax highlighted!!!!). The concept was to make dependent types more accessible to the 'average programmer', that is, one who has not done any functional programming (like most the people at this conference). While the syntax looked pretty good and definitely seemed more readable for such a programmer, I'm not really sure what the use case is because it is a 'read-only' language in the sense that to write in this language still requires proofs to type check, but I have absolutely no idea how this could be presented to the average imperative programmer who has no knowledge of this and maybe not even the mathematical understanding to write or understand them. In fact, how would this such a programmer even read a program with a proof?? I suspect it would come across as completely foreign to them. It'll be interesting to see how these issues are addressed in the future (this talk was about still very early stage reaearch).

## [HATRA](https://conf.researchr.org/home/icfp-splash-2025/hatra-2025): [Decomposable Type Highlighting in Hazel](https://conf.researchr.org/details/icfp-splash-2025/hatra-2025-papers/2/Decomposable-Type-Highlighting-for-Bidirectional-Type-and-Cast-Systems)
Finally, we get to my talk! It actually somehow went faster than in the practice I had this morning, and felt like it went reasonably well for a first talk. 

Briefly, my work has developed a formal foundation and peiminary implementation for highlighting parts of an expression and it's surrounding context which contribute to the type of the expression.<fn>OR, more precisely, it doesnt highlight all parts which provably do not contribute (along a specific path in the lattice).</fn> Importantly, you can decompose the highlighting to take only the subpart of a type which you want to explain/look at, making it an interactive tool. I'll be posting an extended summary/abstract of the work itself and a review of future directions on a separate later post.

I got a couple of good questions plus some very fruitful discussion afterwards during the break. One attendee actually hinted me towards using least upper bound for a part of the research which I had struggled to formalise back while doing my [undergrad dissertation](/papers/dissertation) to make the highlighting include _both_ if statement branches rather than just one; of course, this generally ends up in too much code being highlighted but is an interesting theoretical idea, corresponding to not highlighting all terms which are provably not involved in deriving the type of the expression.

I was also able to discuss how the ideas might extend to allow non-local type information to be incorporated into this method, by 'gluing together' multiple program slices into another valid program. The current implementation already does this to an extent with respect to bindings (and their type slices), but what I really want is a formal foundation for this which can also be applied to a type system including unification or constraints allowing non-local inference (which is where confusion arises most, and where the tool would be most useful). The biggest issue is these glued programs are no longer slices of the original program; maybe I need a relaxation of slicing that allows restricted and orincipled restructuring of the program. This is a difficult problem which i will be considering as part of my master's project.

My main hope at this workshop was to get ideas on how to improve my UI for this tool, and I had a good discussion with someone afterwards about how to effectively select parts of the type of a term to focus on. This is non-trivial as the selections need to either select a slice or sub-term of the type, we can't just arbitrarily select any characters in the string representation and even if we could we still need to translate this back into a type. Options considered were both flat representations, i.e. clicking the text directly but with restrictions or toggling vs some more sophisticated tree based interfaces which could allow more 'continuous' selection<fn>Selecting/drawing ovals around branches in a tree, which is guaranteed to produce a well formed slice/sub-term</fn>, but this might be less efficient for an experienced user. I suspect represented types as trees could also help learners as it makes explicit the precedence rules.

Anyway, very fruitful discussion, though perhaps less discussion about the core UI mechanism and human aspects than I desired.

## [ICFP](https://icfp25.sigplan.org/): [Functional Networking for Millions of Docker Desktops](https://icfp25.sigplan.org/details/icfp-2025-papers/21/Functional-Networking-for-Millions-of-Docker-Desktops-Experience-Report-)
Brilliant talk by my supervisor [Anil](https://anil.recoil.org/) on how docker for desktop was initially created, focusing on the use of OCaml for core parts of the HyperKit and Vpnkit. That is, docker had to run on a Linux kernel, so for Mac they needed to simulate this, which they did by working out how to exploit the hypervisor for this, and then also used Ocaml for the networking, which also required some sort of spoofing to make it look like the packets were coming from the Mac OS rather than a rogue Linux kernel (which would look like a virus).

It's a really amazing example of how Ocaml can be used for really low level programming, even before the advent of modern features like multicore Ocaml and OxCaml. Hopefully more people use Ocaml for low level projects now we have even more sophisticated features!!

## [Hatra](https://conf.researchr.org/home/icfp-splash-2025/hatra-2025): [Types as a Specification Language for Creativity](https://conf.researchr.org/details/icfp-splash-2025/hatra-2025-papers/1/Types-as-a-Specification-Language-for-Creativity)
This was an interesting talk on the idea of splitting a typing system into a pair of soft rules and hard rules: those that _should_ be followed and those which _must_ be followed. The application was for music counterpoint where some rules are just guidelines and others are more strict (e.g. intervals of 2nd and 7ths are hard and must never be used while 5ths and octaves are soft). Then a scoring system, somewhat similar to effect systems,<fn>i.e. being accumulated over a sequence of notes in the same way effects can be accumulated.</fn> is used to score the violation of soft rules (scoring 'how well' it meets the type system).

This definitely seems like it can be extended into an interesting way to formalise the ideas of 'warnings' (yellow squiggles) in programming static checkers. 

The talk was quite short so we had a lot of time for questions, most of which focused on the art aspect. One person noted that even these hard rules are intentionally broken by experienced composers, yet the type system categorically disallows this; I note that a system like Hazel could still be used that marked errors, but still treats it as a valid program, in this situations letting the music play even with errors. Though, at thus point the distinction between hard and soft rules is blurred. 

I had two questions in particular about how the type system could accommodation dependent rules, like forbidding parallel fifths, or preferring contrary motion. Apparently Youyou has formalised this but we didn't have any time to talk about this as she left early. One way to encode this that I did suggest was using type level functions, like a form of System F. Of course, dependent types are the way to go to model complex rules, but I suspect simple rules like parallel 5ths can be represented directly with only types and <code>if</code> statements in a system F style type-level language.

## [HATRA](https://conf.researchr.org/home/icfp-splash-2025/hatra-2025): Discussion
There was a discussion session put on which I thought was an interesting idea, hoping I could maybe get some more HCI related feedback on my work, or discuss other ideas. But, it ended up trying to be a session to come up with theories for HCI at a high level, not relating to much specifically. While I definitely had some good discussion about how people reason about programming (notional machines), I don't think it really got anywhere substantive...

## Thoughts
Happy to have my talk dine, and another good set of talks to attend today. We later went out for dinner with Cyrus and were able to discuss my future plans in more detail. Turned out that [Roly](https://dynamicaspects.org/research/) (who I'd never met before) was also joining, and we had some great discussion where he really did seem to get the fundamentals of what I was talking about. Roly's work on slicing methods were a big inspiration for the initial directions that my work took back a year ago. I definitely recommend reading [Functional Programs that Explain their Work](https://doi.org/10.1145/2364527.2364579) for a great accessible paper of one particular slicing method.
