---
title: Duality of Recursion
---

### Background
One of the first difficult conecepts I encountered during my computer science education was recursion. It's notoriously difficult to teach, but fortunately my first language was Racket, where recursion is the only construct for control flow supported by the core language, so I had to understand it to create any programs of interest. As my education continued I encountered recursion in many different contexts: computing the length of lists, generating all subsets of a list, generating all possible permuations and combinations, tree traversals, and parsers. In fact, during my exploration of [99 Haskell Problems](https://wiki.haskell.org/H-99:_Ninety-Nine_Haskell_Problems) (problem 26) I discovered the duality of recursion and corecursion, which until now I did not fully grasp. This post details my path to understanding this relationship.

### Simplicity of Recursion
Recursion is elegant in its simplicity, a small equation can be applied to problems of arbitrary size, and that's often the most compelling reason for its use. However there are some drawbacks (at least in languages without tail-call optimization). Mainly that the call stack can increase in size arbitrarily. Let's look at an in-depth example from above: generating all possible combinations of a given size from a list. Here's the starting type signature for this function `[a] -> Int -> [[a]]`. It first takes a list of elements, the size of the combinations to generate, and returns the list of combinations of that size. For example generating all 2-combinations of `['a', 'b', 'c']` yields `[['a', 'b'], ['a', 'c'], ['b', 'c']]`. Let's try and derive the recurrence relation for this problem to sketch an idea of our solution. More examples are listed below:

```haskell
combs ['a', 'b', 'c'], 2 = [['a', 'b'], ['a', 'c'], ['b', 'c']]
combs ['a', 'b', 'c'], 1 = [['a'], ['b'], ['c']]
combs ['a', 'b', 'c'], 0 = [[]]

combs ['a', 'b'], 2 = [['a', 'b']]
combs ['a', 'b'], 1 = [['a'], ['b']]
```

Looking closely at these examples, we can see that `combs ['a', 'b', 'c'], 2` depends on `combs ['a', 'b'], 2` 
and `combs ['a', 'b'] 1` with the missing element `'c'` appended to its sublists. Let's see if this works with `combs ['a', 'b', 'c'], 1`. 

### Optimizing Recursion with Memoization


### Tail-Call Optimization

### Flipping Recursion On Its Head

### Optimizing Corecursion with Dynamic Programming


<script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
