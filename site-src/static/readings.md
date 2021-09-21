---
title: Reading List
---
## Reading List
This is a list of reading material that I've personally found useful to learn key concepts in programming language design, functional programming and deep learning.

***

### Programming Languages

***

#### [Design Concepts in Programming Languages](https://mitpress.mit.edu/books/design-concepts-programming-languages)
This text provides a detailed introduction into programming language design with both semantic theory and hands-on implementations.

***

#### [Brown University CS1730: Programming Languages](https://cs.brown.edu/courses/cs173/2014/assignments.html)
Learning to design programs by writing gradually more complex interpreters - it's the best way I've found to learn about programming language design.

***

#### [Continuation Passing Style](https://en.wikibooks.org/wiki/Haskell/Continuation_passing_style)
This is the Haskell wikibook chapter on continuation passing style, it is a great introduction with use cases for CPS and runnable examples.

***

#### [Argument against CallCC](http://okmij.org/ftp/continuations/against-callcc.html)
A discussion of the drawbacks of a general CallCC (Call With Current Continuation) construct.

***

#### [Introduction to Programming with Shift and Reset](http://pllab.is.ocha.ac.jp/~asai/cw2011tutorial/main-e.pdf)
A simple introduction to utilizing delimited continuations (a proposed alternative to CallCC)

***

#### [CPS-SSA Correspondence](https://www.cs.purdue.edu/homes/suresh/502-Fall2008/papers/kelsey-ssa-cps.pdf)
This paper discusses the correspondence between static-single-assignment and continuation passing style.

***

### Functional Programming

***

#### [Functional Programming with Bananas, Lenses, Envelopes and Barbed Wire](https://maartenfokkinga.github.io/utwente/mmf91m.pdf)
This paper will blow your mind! It will show how recursion can be entirely abstracted away in functional programming and enable you to iterate over complex data types without any boilerplate.

***

#### [Introduction to Recursion Schemes](https://blog.sumtypeofway.com/posts/introduction-to-recursion-schemes.html)
This blog post provides a guide to the above paper with runnable code and incremental implementation of the main combinators described in the paper.

***

#### [Notions of Computation and Monads](https://www.cs.cmu.edu/~crary/819-f09/Moggi91.pdf)
Moggi's paper introducing the monad as a way of structuring functional progams.

***

#### [Learn you a Haskell for Great Good](http://learnyouahaskell.com/chapters)
I use this as a solid reference for aspects of Haskell that I'll sometimes forget, it's elementary but extensive and detailed.

***

#### [All About Monads](https://wiki.haskell.org/All_About_Monads)
A great introduction to a fundamental design pattern for functional programming, monads. It helped me to read a lot of tutorials and come to a general understanding that in short, monads implement a context-sensitive composition operator, but read on for more detail.

***

### Deep Learning

***

#### [Attention is All You Need](https://arxiv.org/abs/1706.03762)
This paper introduces the tranformer architecture as a model for numerous language tasks without the drawbacks of serial computation used by RNNs.

***

#### [Long Short-Term Memory](https://www.researchgate.net/publication/13853244_Long_Short-term_Memory) 
This paper introduces the LSTM unit as a tool for sequence modeling. It provides a nice  motivation for the design of the LSTM.

***

#### [Overview of Computational Complexity for Gradient-Based Learning Algorithms](https://web.stanford.edu/class/psych209a/ReadingsByDate/02_25/Williams%20Zipser95RecNets.pdf)
This provides a really nice survey of different gradient based learning methods and how they are derived from first principles.

***

#### [LSTM Recurrent Networks Learn Simple Context Free and Context Sensitive Languages](ftp://ftp.idsia.ch/pub/juergen/L-IEEE.pdf)
This paper shows where LSTMs fit in the [Chomsky Hierarchy](https://en.wikipedia.org/wiki/Chomsky_hierarchy).

***

#### [Learning Phrase Representationsusing RNN Encoder–Decoder for Statistical Machine Translation](https://arxiv.org/pdf/1406.1078.pdf)
This introduces the GRU and provides detail on the motivating scenario for the unit.

***

#### [Neural Machine Translation By Jointly Learning To Align and Translate](https://arxiv.org/pdf/1409.0473.pdf)
This introduced the concept of attention in neural models. Attention is a widely used technique that essentially models an importance function that will be applied to inputs in order to inform the model about which inputs are the most informative for its operation. 

***

#### [Hierarchical Attention Networks for Document Classification](http://www.cs.cmu.edu/~./hovy/papers/16HLT-hierarchical-attention-networks.pdf)
This is an example of a model which utilizes attention in  a straightforward way. This serves as an alternative example to [Neural Machine Translation By Jointly Learning To Align and Translate](https://arxiv.org/pdf/1409.0473.pdf).

***

#### [Generative Adversarial Nets](https://papers.nips.cc/paper/5423-generative-adversarial-nets.pdf)
This introduced Generative Adversarial Networks, a powerful tool for sampling from arbitrary distributions in an entirely unsupervised way.

***
