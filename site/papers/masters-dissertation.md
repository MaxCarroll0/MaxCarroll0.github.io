  <paper-title>Polymorphic Type Slicing</paper-title>
  <paper-date>2026-05-21</paper-date>
  <paper-pages>62</paper-pages>
  <paper-conference>Master's Dissertation, https://www.cst.cam.ac.uk/teaching/part-iii/projects</paper-conference>
  <paper-type>Other</paper-type>
  <tags>Programming Language Design, Interactive Debugging, Type Systems, Type Errors, Hazel, Bidirectional Types, Gradual Types, Polymorphism, Mechanisation, Proof Assistants, Agda</tags>
  <paper-abstract>This dissertation formalises and mechanises type slicing: a way to explain program types by highlighting minimal program fragments. A programmer can select a sub-term and ask why it has some type information, receiving both the relevant code inside the term and the surrounding context that contributes to the answer. The work develops the theory in a bidirectional gradually typed core calculus with explicit polymorphism, products, and sum types, introduces context-classification judgements for separating local and contextual type information, extends the approach to ill-typed programs using error marks, mechanises the main metatheory in Agda, and implements an approximation in Hazel.</paper-abstract>
  <paper-authors>Max Carroll | https://maxcarroll0.github.io</paper-authors>
  <paper-artifacts>Artifact | PDF (download) | /assets/papers/Carroll-Polymorphic_Type_Slicing_Dissertation.pdf, Link | Live Build | https://hazel.org/build/type-slicing/, Link | Hazel Code Branch | https://github.com/hazelgrove/hazel/tree/type-slicing, Link | Formalism Code | https://github.com/MaxCarroll0/polymorphic-type-slicing-formalism/tree/main, Link | TeX Source | https://github.com/MaxCarroll0/polymorphic-type-slicing-tex/tree/main</paper-artifacts>
  <paper-pdf>/assets/papers/Carroll-Polymorphic_Type_Slicing_Dissertation.pdf</paper-pdf>

## Notes
Completed as my **master's dissertation** at the University of Cambridge in 2026.

This project continues the type-slicing thread from my [undergraduate dissertation](/papers/undergrad-dissertation) and the [HATRA 2025 workshop paper](/papers/workshops/HATRA-decomposable-type-highlighting). The emphasis here is on the polymorphic and bidirectional core theory: type slicing is treated as a general explanation mechanism for synthesized types, analyzed contextual expectations, and type errors in incomplete or erroneous programs.

## Context
The dissertation separates two questions that ordinary type tooling often conflates: what type information is attached to a selected expression, and which parts of the program are responsible for it. This is especially important in bidirectional systems, where information can flow from a term to its context or from a context into a term. The dissertation develops this as a metatheory of minimal slices and context classification, with mechanised Agda proofs and a Hazel implementation intended to make those explanations interactive.

## Continued Work
This work has been developed further into the [Bidirectional Type Slicing POPL preprint](/papers/bidirectional-type-slicing-popl-preprint).
