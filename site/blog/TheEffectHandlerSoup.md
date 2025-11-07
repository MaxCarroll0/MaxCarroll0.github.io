<post-metadata>
  <post-title>The Effect Handler Soup — Pushing Effect Handlers into the Mainstream</post-title>
  <post-date>2025-11-01</post-date>
  <post-tags>Effect Handlers, Algebraic Effects, Programming Languages, Functional Programming, Monads</post-tags>
</post-metadata>

Effect Handlers are one of the hot topics in programming language research at present. While the original ideas of effect systems<fn>That is, the idea of <i>effect operators</i>. Effect handlers being more recent.</fn> are “old” (Lucassen and Gifford 1988; Lucassen 1987)<fn>Coinciding with the <i>application</i> of monads to programming by Moggi (1989, 1991).</fn>, there has been an accelerating flurry of research in the last 15 years since effect handlers were introduced (Plotkin and Pretnar 2009), leaving a soup of possibilities to choose from and explore when designing and implementing an effect handler system.

Here I consider the various <i>ideals</i> to strive for to handle effectful programs in a principled manner alongside the many <i>features and research directions</i> to choose from when designing or implementing an effect system. I argue which choices could strike a good balance between the ideals in such a way that could push effect handlers into the mainstream, with reference to the most mainstream <i>built-in</i> implementation currently available (OCaml; Sivaramakrishnan et al. 2021) and established ways of dealing with effects (monadic effects). A good overview of effect-related work can be found in <a href="https://github.com/yallop/effects-bibliography">Yallop’s Effects Bibliography</a>.

## Ideals

### Combining the Functional and the Imperative
There has been a persistent divide between two programming paradigms: <i>pure functional code</i><fn>Without side effects.</fn>, which is often easier to mathematically reason about and prove correct, and <i>imperative code</i><fn>With side effects.</fn>, which is easier to interact with the “real world.”  
Effectful programming should retain the benefits of functional programming, but at present most languages leave a distinct barrier between effectful and pure code.<fn>Via insufficient language features to reason about effects, or by focus on purity hindering interaction with the real world.</fn>

### Modularity & Flexibility
We should be able to write effectful programs but define the semantics of these effects elsewhere (modularity) and in different ways (flexibility) for maximum code re-use. This improves maintainability by reducing and segmenting code, allows greater abstraction, and improves readability by separating concerns between reasoning about effects and programs using them.

### Compositionality
Just like in pure functional code, we should still be able to build larger effectful programs out of small ones. This improves scalability and maintainability by composing complex behaviour from smaller parts.

### Extensibility
New behaviour should be possible to declare and define without modifying existing code, improving scalability.

### Expressivity
As many effects as possible should be expressible within a unified system.

### Convenience
The system should be <i>easy to use</i> and not impose too heavy a conceptual or syntactic burden on the programmer, as these are some of the largest barriers to widespread adoption.

### Safety
The compiler should be able to prove properties about the effects—for example, that an exception will not occur. This helps ensure code reliability.

### Efficiency
The implementation should be fast enough to be useful in performance-critical applications.

---

## Effect Handlers & Monads

There are many ways to reason about effects. But perhaps the only “mainstream” way that both works directly within the language (unlike separation logic) and is fully general (unlike session types, which focus on concurrency, or linear types, which focus on memory) are monads. But even monads have yet to become common in general use.<fn>Strictly speaking, they are used a lot unknowingly, but usually in specific situations (e.g. error handling) rather than in general.</fn>

Here I briefly explain effect handlers, and how their core ideas achieve some of the ideals to a greater extent than monads. For more on monads and monad transformers, see <a href="https://bartoszmilewski.com/2016/11/30/monads-and-effects/">Monads and Effects</a> and <a href="https://blog.cofree.coffee/2021-08-05-a-brief-intro-to-monad-transformers/">A Brief Intro to Monad Transformers</a>.

The core idea of effect systems and handlers is the <i>separation between syntax and semantics</i>. This idea is ubiquitous in all effect handler research and has been considered in computer science since the development of denotational semantics (Scott and Strachey 1971), where we have the concrete syntax of a program separated from its <i>denotation</i>, which specifies the semantics of the terms in a <i>compositional</i> way.<fn>Defining the denotation of a larger expression is done directly in terms of the denotations of its subterms.</fn>

Concretely, effect systems add <i>operations</i> which define extra abstract syntax to programs. For example, consider representing non-determinism; we can add two effect operations (in pseudo syntax):

<div class="language-ocaml">
effect choose : 'a * 'a -> 'a
effect fail : 'a
</div>

This extends the available syntax to allow abstract syntax such as <code>choose (choose (true, false), fail)</code>, while the operations’ behaviour (denotation) is left abstract. We haven’t yet decided whether we want to return all solutions, one, or a random one, or in what order. We instead denote this behaviour by wrapping a handler <i>around</i> the term. For example, the handler below uses lists to accumulate all solutions:

<div class="language-ocaml">
handle ... with 
  | x -> [x]
  | effect choose (x, y) -> (resume x) @ (resume y)
  | effect fail -> resume []
</div>

This is inherently <i>modular</i>: the abstract syntax (effect signature), the handler, and the term are defined (mostly)<fn>The term depends on the defined effects, but these can be shared.</fn> independently. Further, handlers are <i>compositional</i>: they can handle any subset of the effects, and multiple handlers can be nested (composed).  
This contrasts with monads, where one must decide <i>which</i> nondeterminism monad to use (<code>List</code>, <code>Maybe</code>, etc.) in the type, and this must handle all the operations.

Effect signatures are also extensible: you can add any additional abstract syntax at any time without changing existing code. In OCaml (Sivaramakrishnan et al. 2021), this is implemented via an extensible (open) data type (Löh and Hinze 2006).  
With monads, you’d need to change all the types.

Of course, <i>monad transformers</i> remedy these issues with monads to an extent, but in return are much more <i>inconvenient</i>: the programmer must write <code>lift</code> functions for each monad transformer and ideally prove that they satisfy the lift laws. There is also a syntactic burden in having to use the lift function.

---

## Decisions

For a system like effect handlers to reach the mainstream, it must provide substantial benefits to quantifiable aspects of programming at minimal cost.  
Thus, I would argue that **convenience** is the most important aspect to avoid hindering adoption, while **modularity**, **flexibility**, and **extensibility** are the biggest attractions.  
Most popular languages have little enforcement of safety principles, nor do most programs require the most complicated forms of control flow which cannot easily be expressed with standard effect handlers<fn>Like scoped effects.</fn>.

On the other hand, modularity, flexibility, and extensibility are core ideas behind most modern paradigms (for example, the four pillars of OOP or modular programming<fn>It’s literally in the name...</fn>).

Efficiency is crucial in lower-level languages, but I would argue that the biggest barrier to adoption is the lack of implementations and conceptual understanding. Either way, effect handlers can be implemented without significant performance <i>burden</i><fn>At least compared to monadic effects.</fn>: for example by compilation to CPS, by compilation into C via evidence passing (Xie and Leijen 2021), or by stack switching as in the OCaml implementation (Sivaramakrishnan et al. 2021).

---

### Syntax & Style

#### Direct vs Monadic Style
Perhaps the biggest reason monads didn’t catch on widely is the need to write in monadic rather than direct style.  
In practice, monadic languages have a “do notation” to make code look more direct, but it can obscure types, requiring mental translation back to explicit monadic style. It also forces sequential code, whereas direct style does not.

Direct-style effects combine functional properties (compositionality, etc.) with the direct imperative style most programmers are familiar with. These benefits also apply in imperative languages that implicitly use monadic or non-direct code via constructs like Futures or Tasks (<a href="https://learn.microsoft.com/en-us/dotnet/standard/parallel-programming/task-based-asynchronous-programming">Microsoft 2024</a>).

#### Built-in vs Libraries
Some languages provide built-in effects, either designed specifically for them—such as Frank (Convent et al. 2020) and Koka (Leijen 2014)—or retrofitted into existing languages like OCaml (Sivaramakrishnan et al. 2021).  
Built-in support allows a more direct style and better optimisation opportunities. However, adopting new languages is a massive hurdle, and retrofitting is difficult, requiring considerations like:

- Integration with the existing type system.<fn>Clearly very hard, as demonstrated by OCaml’s ongoing lack of an effect system despite years of work.</fn>  
- Compatibility with existing compilation methods. For example, OCaml’s effects cannot use CPS-style conversions as in Koka and Frank. In principle, CPS translation or evidence passing (Xie and Leijen 2021) could be used as a rewriting step from OCaml (with handlers) → OCaml (without handlers), but this would lose compatibility with existing debugging tools such as those relying on DWARF unwind tables (<a href="https://dwarfstd.org/">DWARF Committee 2025</a>).  
- Ensuring both forwards and backwards compatibility.

Where possible, built-in extensions to existing languages would expand the audience most.

---

### Semantics

#### Shallow vs Deep Handlers
Shallow and deep effect handlers each have advantages in particular use cases. Shallow handlers allow control over how effects are handled in the continuation.  
An example is “pipelines”<fn>Like in Unix.</fn> where two dual handlers, <code>pipe</code> and <code>copipe</code>, can alternate to send and receive values.

While both forms of handlers can simulate each other, simulating shallow using deep handlers is too inefficient (Hillerström and Lindley 2018).  
For maximum convenience, we could implement shallow handlers and encode deep ones.<fn>As deep handlers are more common in practice, it might make sense to optimise deep handlers instead. But as stated, I would prioritise convenience and expressivity over efficiency initially.</fn>

#### Single-shot vs Multi-shot Continuations
OCaml focuses on single-shot continuations as a good trade-off between complexity and practicality, given most usage fits this case. However, support for multi-shot continuations is still desirable, especially for non-deterministic programming.

#### Non-Algebraic Effects
Not all effects are algebraic. Several ideas remedy this, like scoped effects (Wu, Schrijvers, and Hinze 2014).  
While examples in nondeterminism and backtracking motivate scoped effects, existing handler expressivity likely already suffices.

#### Multihandlers
The shallow vs deep section centred on pipelines being easier to express with two alternating shallow handlers. However, multihandlers, as in Frank (Convent et al. 2020), allow operations to raise and handle multiple effects at once. While more direct, the benefit over explicit shallow composition is debatable.

#### Dedicated Handlers
At ICFP I attended a talk on <i>smart handlers</i> (Xie 2025; Plotkin and Xie 2025), which introduce “cost continuations,” useful for expressing optimisation problems, hyperparameter tuning, and game theory.  
While such dedicated features are extremely useful, building direct support for them shouldn’t be an initial focus—they could instead live in libraries or be compiled to regular handlers. Consider the popularity and effectiveness of libraries in Python and JavaScript.

---

### Types

#### Effect Safety
Effect systems can statically guarantee that all effects have been handled, improving safety and even convenience by allowing IDE suggestions for unhandled effects.  
However, even without effect safety, handlers would fit alongside unsafe constructs like nulls and unchecked exceptions.<fn>Of course, in the long term I’m definitely in favour of effect safety.</fn>

As seen in OCaml’s lack of a fully implemented effect system (Sivaramakrishnan et al. 2021), retrofitting such systems into existing languages is hard.  
Given that built-in handlers in major languages are the best path to a large audience, effect safety might be worth omitting initially.

#### Effect Polymorphism
Effect polymorphism is immensely useful in higher-order code—for example, when we want effects raised by higher-order function parameters to be handled at the call site.  
However, this often requires verbose annotations, which burden convenience. Frank (Convent et al. 2020) uses “abilities,” declaring handled effects from the inside out, avoiding explicit effect variables in most cases.  
Similarly, Effekt uses “contextual effect polymorphism” to pass effects from higher-order function parameters directly to the call site.  
Despite differing semantics, Effekt’s polymorphism is strikingly similar to Frank’s concept of <i>ambient ability</i>.

---

## References

- Lucassen, John M. and David K. Gifford. 1988. *Polymorphic Effect Systems*. POPL ’88. ACM Press.  
- Lucassen, John M. 1987. *Types and Effects: Towards the Integration of Functional and Imperative Programming*. PhD Thesis, MIT.  
- Moggi, Eugenio. 1989. *Computational Lambda-Calculus and Monads*. LICS ’89. IEEE Press.  
- Moggi, Eugenio. 1991. *Notions of Computation and Monads*. *Information and Computation* 93(1):55–92.  
- Plotkin, Gordon and Matija Pretnar. 2009. *Handlers of Algebraic Effects*. *ESOP ’09*. Springer.  
- Scott, Dana and Christopher Strachey. 1971. *Toward a Mathematical Semantics for Computer Languages*. OUCL Technical Report PRG-6.  
- Sivaramakrishnan, K.C. et al. 2021. *Retrofitting Effect Handlers onto OCaml*. *PLDI ’21*. ACM.  
- Löh, Andres and Ralf Hinze. 2006. *Open Data Types and Open Functions*. *PPDP ’06*. ACM.  
- Xie, Ningning and Daan Leijen. 2021. *Generalized Evidence Passing for Effect Handlers*. *Proc. ACM Program. Lang.* ICFP.  
- Convent, Lukas, Sam Lindley, Conor McBride, and Craig McLaughlin. 2020. *Frank: Doo Bee Doo Bee Doo*. *J. Funct. Program.* 30:e9.  
- Leijen, Daan. 2014. *Koka: Programming with Row Polymorphic Effect Types*. *EPTCS* 153:100–126.  
- Hillerström, Daniel and Sam Lindley. 2018. *Shallow Effect Handlers*. *Programming Languages and Systems*. Springer.  
- Wu, Nicolas, Tom Schrijvers, and Ralf Hinze. 2014. *Effect Handlers in Scope*. *SIGPLAN Not.* 49(12):1–12.  
- Plotkin, Gordon and Ningning Xie. 2025. *Handling the Selection Monad*. *Proc. ACM Program. Lang.* PLDI.  
- Xie, Ningning. 2025. *Smart Handlers: Handling the Selection Monad*. *HOPE Workshop, ICFP/SPLASH 2025*.  

