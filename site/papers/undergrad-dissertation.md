  <paper-title>Type Error Debugging in Hazel</paper-title>
  <paper-date>2025-05-12</paper-date>
  <paper-pages>78</paper-pages>
  <paper-conference>Undergraduate Dissertation, https://www.cst.cam.ac.uk/teaching/part-ii/projects</paper-conference>
  <paper-type>Other</paper-type>
  <tags>Programming Language Design, Debugging, Type Systems, Hazel, HCI, Type Errors, Dynamic Type Errors, Bidirectional Types, Gradual Types, Dynamic Types, Lattices, Nondeterminism, Dynamic Analysis, Program Generation, </tags>
  <paper-authors>Max Carroll | https://maxcarroll0.github.io</paper-authors>
  <paper-artifacts>Artifact | PDF (download) | /assets/papers/Carroll-undergrad_dissertation.pdf, Link | Online Interpreter | https://hazel.org/build/witnesses-type-slicing/, Link | Hazel Website | https://hazel.or, Link | Dissertation Source Code | https://github.com/MaxCarroll0/Type-Error-Debugging-in-Hazel---Dissertation/tree/main, Link | Source code | https://github.com/MaxCarroll0/hazel/tree/witnesses-type-slicingg</paper-artifacts>
  <paper-pdf>/assets/papers/Carroll-undergrad_dissertation.pdf</paper-pdf>


## Notes 
Completed as part of a __Bachelor of Arts__ in Computer Science at Cambridge university over the 2024-2025 year. Won the **2nd place prize** with a score of 92.5%.

I am grateful for help provided by my supervisors ([Anil Madhavapeddy](anil.recoil.org) and [Patrick Ferris](patrick.sirref.org)) throughout this project. Especially Patrick's creation of a basic [OCaml to Hazel transpiler](https://patrick.sirref.org/hazel-of-ocaml/index.xml), that supported translation of __both__ well-typed and ill-typed OCaml code.

## Original Aims
This project seeks to explore ways to improve type error debugging. Traces to dynamic type errors can provide better intuition to why static type errors were found. Additionally, dynamic errors do not often point directly back to source code, or do so only incompletely. This project aimed to create a source code highlighting system for dynamic errors and an automated search procedure for dynamic errors. The Hazel language was chosen, allowing the project to explore both static and dynamic errors and their interaction. Only a subset of Hazel was expected to be supported, but enough to demonstrate the methods’ promise.

## Work Completed
The project successfully supports almost all of Hazel. Hazel is an intensely active research project so significant work went into staying up to date and producing a corpus of Hazel programs. Four searching methods were implemented, the best failing to find existing dynamic errors for only 2% of the corpus. Dynamic error highlighting had no prescribed basis to build upon. Therefore, a very significant part was devising novel formalisations for type-directed highlighting systems which propagate information throughout evaluation; further extended to explain static errors also. Both error highlighting implementations were found to be concise and demonstrated to be effective.

## Continued Work
Work on the __type slicing__ aspect of this project has been continued. Including a [progress/summary paper](/papers/workshops/HATRA-decomposable-type-highlighting) accepted to the [HATRA 2025](https://conf.researchr.org/home/icfp-splash-2025/hatra-2025) workshop with my corresponding [talk]().
