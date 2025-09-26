# Book, Paper, & Blog Recommendataions
Some books, papers, and blogs I have read and greatly recommend are listed here. 

## Programming
I love the design and implementation of programming languages. Especially functional programming, where the resources below will be very useful & interesting for other exploring functional programming.
### OCaml
- [Anil Madhavapeddy]() & [Yaron Minsky](): [Real World OCaml]() (2nd ed.).  
The ideal introduction to learning OCaml, which I highly recommend as a first functional language to learn. Multicore OCaml should be coming in the 3rd edition.

### Data Structures
- [Chris Okazaki](): [Purely Functional Data Structures]().  
A great reference and introduction to immutable & persistent data structures<fn>Where updates preserve old versions of the data structure. Amazingly, this can still be memory efficient!</fn>, from a functional standpoint.  
But, the ideas are also applicable to imperative languages, which can still implement these data structures for use-cases including version control systems, user interfaces<fn>Where being able to roll-back changes is useful.</fn> and concurrency<fn>Where immutability avoids issues with data races.</fn>.

### CDRTs
... recommendations coming eventually

## Programming Language Theory & Design
### Overview & Semantics
Two amazing books which can give a broad and basic understanding of the fundamentals of programming language theory, semantics, and even design & implementation.
- [Benjamin C. Pierce](): [Types and Programming Langauges]() (TAPL).  
I recommend reading this book first, as I find it more accessible and practical<fn>In the sense that there are more examples of the maths and proofs, and a more clear-cut focus on operation semantics.</fn> than Harper's below, and it also contains basic OCaml implementation references which can help understanding the concepts in a more interactive sense.   
However, it is relatively less broad and with less comprehensive formal foundations. 
- [Robert Harper](): [Practical Foundations for Programming Languages]() (2nd ed.).  
This book will expose you to even more interesting programming features and systems, including a wider range of imperative constructs. The only major missing topic vs. those in TAPL is type inference.

Pierce has a sequel which collates in-depth case studies on a select few very interesting features of functional programming languages and topics in programming language theory. I find the chapters on ML-style module systems and type definitions especially interesting.
- [Behamin C. Pierce](): [Advanced Topics in Types and Programming Languages]() (ATTAPL).

### Bidirectional Type Systems
Bidirectional typing systems are a more algorithmic mathematical formalisation of type systems which give local type inference with a very straightforward implementation. I recommend reading the paper below for a an accessible introduction and recipe/rules for this form of type system.  
An example of a project which uses bidirectional types is the [Hazel](https://hazel.org) language.
- [Jana Dunfield]() & [Neel Krishnaswami](): [Bidirectional Typing](https://arxiv.org/abs/1908.05839)

### Refinement Types
... recommendations coming eventually


## Proof Assistants
... recommendations coming eventually

## Mathematics
### Algebra & Discrete Maths & General Mathematical Thinking
Familiarity with algebra and discrete maths is essential for any mathematical reasoning about program, and especially in theoretical programmiing langauge design. The course on discrete maths I took during my undergraduate has possibly been the most widely useful course I took.  
Here I recommend a book for more proof-oriented mathematical thinking, mathematics for use in computer science, and a more pure-mathematics focused book focusing on algebra.
- [Kevin Houston](): [How to Think like a Mathematician]().  
This is a great introduction to ideas in 'real mathematics'. That is, focusing on proving things as opposed to just solving problems as one would typically do in secondary/high school. Changing this way of thinking is essential in order to be able to prove results about programs and model ideas in programming.
- [Donald Knuth](): [Concrete Mathematics]().  
A great pracical book to introduce you to mathematics that is actually useful to a working programmer seeking to prove and explore properties that their programs hold. The extensive corpus of examples, most of which having answers, makes this a great book to use for learning.  
The student notes in the margins can also be pretty funny and useful.
- [Paolo Aluffi](): [Algebra: Chapter 0]().  
While many of the ideas in this book are not directly applicable to computer science, they can be great for more theoretical uses and general mathematical knowledge. This book takes a more categorical approach (see below) to algebra, which demonstrates the connections between many ideas in algebra.

### Category Theory
Category theory can be a really interesting way to view many mathematical ideas, especially those in computer science. I recommend a great book/blog by Bartosz Milewski teaching and demonstrating category theory with a heavy focus on connections to functional programming is a great way to learn it in context with little mathematical knowledge required.   
It can really change the way you think about problems! A more traditional, but still reasonably accessible requiring a little more mathematical background, book by Awodey is also a good option which goes a fair bit deeper into the foundations.
- [Bartosz Milewski](): [Category Theory for Programmings](https://bartoszmilewski.com/2014/10/28/category-theory-for-programmers-the-preface/).
- [Awodey](): [Category Theory]().

### Type Theory
... recommendations coming eventually

### Application to Programming
- [Richard Bird](): [The Algebra of Programming]().
