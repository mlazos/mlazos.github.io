---
title: A Recursive Generating Function for Partial Sums of Pascal's Triangle
---

### Problem
In this post I'll show how to derive a recursive generating function for partial sums of pascal's triangle given a row and column index in the triangle. I discovered this function while attempting to prove analytically that the number of subsets of a set of size $N$ is equivalent summing the number of ways k elements can be chosen from the set with k ranging from 0 to $N-1$. Eq. 1 shows the mathematical statement that will be our starting point.


\begin{equation}
\sum_{k=0}^{N}{N \choose k} = 2^N
\end{equation}

### Derivation
Next let's expand the left side using the definition of $n \choose k$.

<script>
MathJax = {
  tex: {
    inlineMath: [['$', '$'], ['\\(', '\\)']],
    tags: 'ams'
  },
  svg: {
    fontCache: 'global'
  }
};
</script>
<script type="text/javascript" id="MathJax-script" async
  src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-svg.js">
</script>