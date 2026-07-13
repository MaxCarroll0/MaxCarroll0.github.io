  <paper-title>Bidirectional Type Slicing</paper-title>
  <paper-date>2026-07-09</paper-date>
  <paper-pages>28</paper-pages>
  <paper-conference>POPL 2027 preprint under review, https://popl27.sigplan.org/track/POPL-2027-popl-research-papers</paper-conference>
  <paper-type>Conference</paper-type>
  <tags>Programming Language Design, Interactive Debugging, Type Systems, Type Errors, Hazel, Bidirectional Types, Gradual Types, Polymorphism, Mechanisation, Proof Assistants, Agda</tags>
  <paper-abstract>Development tools report what type an expression has, but not why it has that type. This preprint develops type slicing for bidirectional type systems: a programmer selects a term, queries part of its type information, and receives a well-formed partial program that is sufficient to reproduce the queried type. The theory covers synthesis slices for types produced by terms and analysis slices for expectations imposed by contexts, proves existence and monotonicity properties for minimal slices, gives exact and approximate algorithms, extends the account to ill-typed programs using error marking, and connects the metatheory to a Hazel implementation and Agda mechanisation.</paper-abstract>
  <paper-authors>Max Carroll | https://maxcarroll0.github.io, Anil Madhavapeddy | https://anil.recoil.org, Cyrus Omar | https://hazel.org</paper-authors>
  <paper-artifacts>Artifact | PDF (download) | /assets/papers/Carroll-Bidirectional_Type_Slicing_POPL_Preprint.pdf, Link | Live Build | https://hazel.org/build/type-slicing-v2/, Link | Hazel Code Branch | https://github.com/hazelgrove/hazel/tree/type-slicing-v2, Link | Formalism Code | https://github.com/MaxCarroll0/polymorphic-type-slicing-formalism/tree/main, Link | TeX Source | https://github.com/MaxCarroll0/Bidirectional-Type-Slicing-POPL/tree/main</paper-artifacts>
  <paper-pdf>/assets/papers/Carroll-Bidirectional_Type_Slicing_POPL_Preprint.pdf</paper-pdf>

## Notes
This is a non-anonymised preprint of a POPL submission currently under review. It is linked here for context, but please do not circulate it widely while review is in progress.

The paper is a condensed and sharpened version of the theory developed in my [master's dissertation](/papers/masters-dissertation), with a focus on bidirectional type slicing as a general explanation technique rather than as dissertation-scale exposition. The Hazel implementation demonstrates the linear-time approximation in an interactive programming environment, while the Agda formalism mechanises the central metatheory.

## Context
Bidirectional type systems make type information flow in two directions: terms synthesize information upward, and contexts analyze terms against expectations. Type slicing turns those flows into explanations by producing partial programs that preserve just the queried type information. The POPL preprint presents the core theory, algorithms, and error-marking extension in a conference-paper form, and relates the formalism to Hazel's live type-debugging interface.
