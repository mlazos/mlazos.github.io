---
title: A Recursive Generating Function for Partial Sums of Pascal's Triangle
---
<style>

.column {
  display: inline-block;
  width: 33%;
  text-align: center;
  vertical-align: top;
}
.pgrow {
    margin: auto;
    width: 900px;
    padding: 20px;
    text-align: center;
}
.pgrow:after {
  content: "";
  display: table;
  clear: both;
}

table.std {
  border: 0px solid #000000;
  width: auto;
  height: 50px;
  text-align: center;
  border-collapse: collapse;
  margin: auto;
}
table.std caption {
    caption-side: top;
}
table.std td, table.paleBlueRows th {
  border: 1px solid #FFFFFF;
  padding: 3px 2px;
}
table.std tbody td {
  font-size: 13px;
}
table.std tr:nth-child(even) {
  background: #CECECE;
}
table.std thead {
  background: #545454;
}
table.std thead th {
  width: 100px;
  font-size: 15px;
  font-weight: bold;
  color: #FFFFFF;
  text-align: center;
  border-left: 1px solid #FFFFFF;
}
table.std thead th:first-child {
  border-left: none;
}

table.std tfoot td {
  font-size: 14px;
}

</style>
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

Letting $f(n,x) = 1 + \frac{n}{x} \cdot f(n-1, x+1)$ for $x > 0$
\begin{align}
\sum_{k=0}^{N}{N \choose k} &= 1 + N \cdot (1 + \frac{N-1}{2} \cdot (1 + \frac{(N-2)}{3} + \cdots + \frac{2 \cdot (N-2)!}{(N-1)!} + \frac{2 \cdot (N-2)!}{N!})) \\
&= 1 + N \cdot (1 + \frac{N-1}{2} \cdot (1 + \frac{(N-2)}{3} \cdot (1 + \cdots (1 + \frac{2}{N-2} \cdot (1 + \frac{1}{N}(1)))\\
&= f(N, 1)
\end{align}

That concludes the derivation of this function and why it's equivalent to the usual definition of the subset counting function in Eq. 1.

### Numerical Experiments
Now let's write a small program to explore the behavior of this function.  A possible implementation is presented below in Haskell.
```
partialPasc :: Rational -> Rational -> Rational
partialPasc _ 0 = 1
partialPasc 0 _ = 1
partialPasc n x = 1 + n / x * (partialPasc (n - 1) (x + 1))
```

Below is the recursive call chain with arguments $(4, 1)$
```
*Main> partialPasc 4 1
16 % 1
*Main> partialPasc 3 2
15 % 4
*Main> partialPasc 2 3
11 % 6
*Main> partialPasc 1 4
5 % 4
*Main> partialPasc 0 5
1 % 1
```
Note: the `%` above is the symbol for a fraction of two integers with the haskell `Rational` datatype.

<div class="pgrow">
<div class="column">
<table class="std">
<caption>$N=6$</caption>
<thead>
<tr>
<th>$n, x$</th>
<th>$f(n, x)$</th>
</tr>
</thead>
<tbody>
<tr>
<td>$6, 1$</td>
<td>$64$</td>
</tr>
<tr>
<td>$5, 2$</td>
<td>$\frac{63}{6}$</td>
</tr>
<tr>
<td>$4, 3$</td>
<td>$\frac{57}{15}$</td>
</tr>
<tr>
<td>$3, 4$</td>
<td>$\frac{42}{20}$</td>
</tr>
<tr>
<td>$2, 5$</td>
<td>$\frac{22}{15}$</td>
</tr>
<tr>
<td>$1, 6$</td>
<td>$\frac{7}{6}$</td>
</tr>
<tr>
<td>$0, 7$</td>
<td>$1$</td>
</tr>
</tbody>
</table>
</div>
<div class="column">
<table class="std">
<caption>$N = 5$</caption>
<thead>
<tr>
<th>$n, x$</th>
<th>$f(n, x)$</th>
</tr>
</thead>
<tbody>
<tr>
<td>$5, 1$</td>
<td>$32$</td>
</tr>
<tr>
<td>$4, 2$</td>
<td>$\frac{31}{5}$</td>
</tr>
<tr>
<td>$3, 3$</td>
<td>$\frac{26}{10}$</td>
</tr>
<tr>
<td>$2, 4$</td>
<td>$\frac{16}{10}$</td>
</tr>
<tr>
<td>$1, 5$</td>
<td>$\frac{6}{5}$</td>
</tr>
<tr>
<td>$0, 6$</td>
<td>$1$</td>
</tr>
</tbody>
</table>
</div>

<div class="column">
<table class="std">
<caption>$N=4$</caption>
<thead>
<tr>
<th>$n, x$</th>
<th>$f(n, x)$</th>
</tr>
</thead>
<tbody>
<tr>
<td>$4, 1$</td>
<td>$16$</td>
</tr>
<tr>
<td>$3, 2$</td>
<td>$\frac{15}{4}$</td>
</tr>
<tr>
<td>$2, 3$</td>
<td>$\frac{11}{6}$</td>
</tr>
<tr>
<td>$1, 4$</td>
<td>$\frac{5}{4}$</td>
</tr>
<tr>
<td>$0, 5$</td>
<td>$1$</td>
</tr>
</tbody>
</table>
</div>
<p><b>Figure 0</b>: Example call chains of $f(n, x)$ for select values of $N$</p>
</div>

Looking closely at these examples, a pattern emerges: the numerator of each of these fractions yields the partial sum at position $x - 1$ in the $N$th row of Pascal's triangle, while each denominator is the value at that position. I haven't been able to find a reason for this so far, but will leave further investigation for a follow up when I have the time.

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