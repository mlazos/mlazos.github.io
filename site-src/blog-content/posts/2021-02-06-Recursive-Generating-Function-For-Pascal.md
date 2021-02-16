---
title: A Recursive Generating Function for Partial Sums of Pascal's Triangle
---

### Introduction
In this post I'll show how to derive a recursive generating function for partial sums of [Pascal's Triangle](https://en.wikipedia.org/wiki/Pascal's_triangle) given a row and column index in the triangle. I discovered this function while attempting to prove analytically that the number of subsets of a set of size $N$ is equivalent to summing the number of ways k elements can be chosen from the set with k ranging from 0 to $N-1$.

### Derivation
Eq. 1 shows the mathematical statement that will be our starting point. Note: This equation yields the full sum of row N of Pascal's triangle.

\begin{equation}
\sum_{k=0}^{N}{N \choose k} = 2^N
\end{equation}

Next let's expand the left side using the definition of $n \choose k$ and $\sum_{}^{}$. This yields Eq. 2 and 3 below

\begin{align}
\sum_{k=0}^{N}{N \choose k} &= \sum_{k=0}^{N} \frac{N!}{k!(N-k)!} \\
&= \frac{N!}{0!(N-0)!} + \frac{N!}{1!(N-1)!} + \cdots + \frac{N!}{(N-1)!(N-(N-1))!} + \frac{N!}{N!(N-N)!}
\end{align}

Now reducing the fractions yields:

\begin{align}
\sum_{k=0}^{N}{N \choose k} &= \frac{N!}{N!} + \frac{N!}{(N-1)!} + \cdots + \frac{N!}{(N-1)!} + \frac{N!}{N!} \\
&= 1 + N + \frac{N \cdot (N-1)}{2!} + \cdots + \frac{N!}{(N-1)!} + \frac{N!}{N!} \\
&= 1 + N + \frac{N \cdot (N-1)}{2!} + \frac{N \cdot (N-1) \cdot (N-2)}{3!} + \cdots + \frac{N!}{(N-1)!} + \frac{N!}{N!}
\end{align}

Now let's factor out $N$ from every subsequent term after the first term (the $1$). This is shown in Eq 7.


\begin{align}
\sum_{k=0}^{N}{N \choose k} &= 1 + N \cdot (1 + \frac{N-1}{2!} + \frac{(N-1) \cdot (N-2)}{3!} + \cdots + \frac{(N-1)!}{(N-1)!} + \frac{(N-1)!}{N!})
\end{align}

Let's now factor out $\frac{(N-1)}{2}$ from the subsequent terms after the first *inside the parentheses*.

\begin{align}
\sum_{k=0}^{N}{N \choose k} &= 1 + N \cdot (1 + \frac{N-1}{2} \cdot (1 + \frac{2 \cdot (N-2)}{3!} + \cdots + \frac{2 \cdot (N-2)!}{(N-1)!} + \frac{2 \cdot (N-2)!}{N!}))
\end{align}

Now we can see that we can continue factoring out $\frac{(N - k)}{k + 1}$ until we've run out of terms (ie for $k = N$).

Letting $f(n,x) = 1 + \frac{n}{x} \cdot f(n-1, x+1)$ with $x > 0$
\begin{align}
\sum_{k=0}^{N}{N \choose k} &= 1 + N \cdot (1 + \frac{N-1}{2} \cdot (1 + \frac{(N-2)}{3} + \cdots + \frac{2 \cdot (N-2)!}{(N-1)!} + \frac{2 \cdot (N-2)!}{N!}))
\end{align}

After repeating this $N$ times, the rightmost term becomes 1. Indicating that $f(0, N+1)=1$
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