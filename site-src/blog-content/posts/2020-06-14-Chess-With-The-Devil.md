---
title: Decoding Devil's Chess
---

<style>
table.parityGroup {
  border: 1px solid #000000;
  background-color: #FFFF;
  width: 65px;
  text-align: center;
  border-collapse: collapse;
  color: #000000;
  margin: auto;
}
table.parityGroup td, table.parityGroup th {
  border: 1px solid #000000;
  padding: 3px 5px;
}
table.parityGroup tbody td {
  font-size: 13px;
  font-weight: bold;
}
table.parityGroup caption {
    caption-side: bottom;
}

.group {
    background-color: #777777;
    color: #39ff14;
}
.column {
  display: inline-block;
  width: 130px;
  text-align: center;
}

/* Clear floats after the columns */
.pgrow {
    margin: auto;
    width: 900px;
    padding: 30px;
    text-align: center;
}
.pgrow:after {
  content: "";
  display: table;
  clear: both;
}
.center-fixed {
  margin: auto;
  width: 400px;
  padding: 20px;
  text-align: center;
}

.center {
  margin: auto;
  padding: 20px;
  text-align: center;
}

table.std {
  border: 0px solid #000000;
  width: 600px;
  height: 200px;
  text-align: center;
  border-collapse: collapse;
  margin: auto;
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
  border-bottom: 5px solid #FFFFFF;
}
table.std thead th {
  font-size: 15px;
  font-weight: bold;
  color: #FFFFFF;
  text-align: center;
  border-left: 2px solid #FFFFFF;
}
table.std thead th:first-child {
  border-left: none;
}

table.std tfoot td {
  font-size: 14px;
}

</style>

A few years ago one of my good friends who was local to Seattle posed to me the Devil's Chessboard puzzle. I couldn't stop thinking about the puzzle day and night. It took me until now to *fully understand* this puzzle and have a full solution that I devised on my own.

### The Problem
You and your friend have been trapped in the underworld, but the devil, as merciful as he is decides he will let you go if you can solve his most devious trick! He whips out an 8x8 chessboard and places quarters over the entire board randomly. He orders your friend to leave the room. Once your friend has left the devil turns to you and says HERE IS THE MAGIC SQUARE and points to a square on the board. Now you must communicate to your friend which square is the magic square by flipping at most one coin. No other communication can be made. The devil, being as fair as he is, allows you to speak to your friend to strategize before making your friend leave the room. Once you have flipped at most one coin (or flipped no coin at all) you leave the room and your friend is invited back in to reveal which square is the magic square.

### Initial Impression
Let's try to come up with some ballpark ideas to try and find a pattern in the problem. Maybe we can us the rows and columns to communicate the row an column of the square in binary? We are dealing with heads and tails here but we're limited to only change at most one bit. Let's see if we can reduce this problem down to a form with an obvious solution.

### Let's Solve a Simpler Problem ...
Going with binary seems to be a good way to think about the problem, so let's try and make the problem small, really really small. A 2x2 board seems easy enough.

<div class="center-fixed">
<div class="column">
<table class="parityGroup">    
    <tbody>
    <tr>
      <td>0</td><td>1</td>
    </tr>
    <tr>
      <td>1</td><td>1</td>
    </tr>
    </tbody>
</table>
</div>
<p><b>Figure 0</b>: Sample 2x2 board</p>
</div>

At a fundamental level, flipping a coin is equivalent to flipping a bit in our board's binary representation of four bits. This by definition changes the parity of a specific row and column but nothing else. We're on the right track here because flipping a coin changes the parity of the board, and since we are explicitly given the option not to flip as well, this gives us a hint that the board could happen to be in the correct configuration already. So how do we use parity to indicate an arbitrary cell? If we number the cells from 0-3 (shown below), we can represent all of those values with a 2 bit integer, we'll call these our index bits. 

<div class="pgrow">
<div class="column">
<table class="parityGroup">   
    <caption>Indices</caption>
    <tbody>
    <tr>
      <td>0</td><td>1</td>
    </tr>
    <tr>
      <td>2</td><td>3</td>
    </tr>
    </tbody>
</table>
</div>
<div class="column">
<table class="parityGroup">
    <caption>Index Bits</caption>
    <tbody>
    <tr>
      <td>00</td><td>01</td>
    </tr>
    <tr>
      <td>10</td><td>11</td>
    </tr>
    </tbody>
</table>
</div>
<p><b>Figure 1</b>: Cell Indices in 2x2 case</p>
</div>

Since in this example we have 2 index bits, (to represent cell indices 0-3), we can try and construct two parity groups. With this small board if we flip any cell, the parity of the row and column of that cell change, but other rows and columns will remain unchanged. If we use one row and one column, we can construct *parity groups* that with a single bit flip can toggle the 0th bit, the 1st bit, *both* or *none at all*. These groups are shown below.

<div class="pgrow">
<div class="column">
<table class="parityGroup">    
    <caption>Group 0</caption>
    <tbody>
    <tr>
      <td>0</td><td>1</td>
    </tr>
    <tr>
      <td class="group">1</td><td class="group">1</td>
    </tr>
    </tbody>
</table>
</div>
<div class="column">
<table class="parityGroup">
    <caption>Group 1</caption>
    <tbody>
    <tr>
      <td class="group">0</td><td>1</td>
    </tr>
    <tr>
      <td class="group">1</td><td>1</td>
    </tr>
    </tbody>
</table>
</div>
<p><b>Figure 2</b>: Parity groups in 2x2 case</p>
</div>

Let's delve into how this will work. Parity is computed by taking the xor ($\oplus$) of all of the values in the group. For single bit values that we have here, $\oplus$ is equivalent to counting up the number of 1's, and if that number is odd, the result is 1, otherwise 0. So in group 0 the number of 1's is 2 which results in a parity of 0. In group 1 the number of 1's is 1 which results in a parity of 1. So the current index indicated by this board layout is 01 which implies cell 1 is the cell picked by the devil. Let's say cell 0 is the one selected by the devil, which cell would we flip? The table below shows this mapping.

<div class="center">
<table class="std">
<thead>
<tr>
<th>Selected Cell</th>
<th>Cell to Toggle</th>
<th>Parity Group Change</th>
<th>Index Bits Change</th>
</tr>
</thead>
<tbody>
<tr>
<td>0</td>
<td>0</td>
<td>Group 0: 1 $\rightarrow$ 0</td>
<td>01 $\rightarrow$ 00</td>
</tr>
<tr>
<td>1</td>
<td>None</td>
<td>No Change</td>
<td>01 $\rightarrow$ 01</td>
</tr>
<tr>
<td>2</td>
<td>2</td>
<td>Group 0: 1 $\rightarrow$ 0, Group 1: 0 $\rightarrow$ 1</td>
<td>01 $\rightarrow$ 10</td>
</tr>
<tr>
<td>3</td>
<td>3</td>
<td>Group 1: 0 $\rightarrow$ 1</td>
<td>01 $\rightarrow$ 11</td>
</tr>
</tbody>
</table>
<br>
<p><b>Figure 3</b>: Cell index to toggle given devil's selection</p>
</div>
<br>

From here, this can easily be extended to any other board layout, the only part that will change are the inital group parity values, the parity groups themselves are enough to enable toggling any subset of the index bits to achieve the desired value.

### Another Example
Let's apply our approach to a more complex problem to see if it generalizes. Let's use the following board.

<div class="center-fixed">
<div class="column">
<table style="width: 100px;" class="parityGroup">    
    <tbody>
    <tr>
      <td>0</td><td>1</td><td>1</td><td>1</td>
    </tr>
    <tr>
      <td>1</td><td>0</td><td>0</td><td>1</td>
    </tr>
    </tbody>
</table>
</div>
<p><b>Figure 4</b>: Sample 2x4 board</p>
</div>

Since we have 8 cells, we will need to determine our cell indices. There are many ways to count the cells, but let's go with the following indices.


<div class="pgrow">
<div class="column">
<table style="width: 100px" class="parityGroup">   
    <caption>Indices</caption>
    <tbody>
    <tr>
      <td>0</td><td>1</td><td>2</td><td>3</td>
    </tr>
    <tr>
      <td>4</td><td>5</td><td>6</td><td>7</td>
    </tr>
    </tbody>
</table>
</div>
<div class="column">
<table style="width:100px" class="parityGroup">
    <caption>Index Bits</caption>
    <tbody>
    <tr>
      <td>000</td><td>001</td><td>010</td><td>011</td>
    </tr>
    <tr>
      <td>100</td><td>101</td><td>110</td><td>111</td>
    </tr>
</table>
</div>
<p><b>Figure 5</b>: Cell Indices in 2x4 case</p>
</div>

So now we have three index bits and we will once again need to toggle any subset of these bits. In this case, the possible subsets of the index bits are $\{0\},\{1\},\{2\},\{0,1\},\{1,2\},\{0,2\},\{0,1,2\}$. Now we simply need to assign each of these subsets a cell index, and we can construct our parity groups. Let's just number them from left to right starting with index 0. This results in the following mapping 
$\{0\} \rightarrow 0,
\{1\} \rightarrow 1,
\{2\} \rightarrow 2,
\{0,1\} \rightarrow 3,
\{1,2\} \rightarrow 4,
\{0,2\} \rightarrow 5,
\{0,1,2\} \rightarrow 6,
\{\} \rightarrow 7$. With this mapping each cell can toggle a subset of the index bits, and we can derive our parity groups in the following way: if a cell can toggle an index, it is in that index's parity group.  This results in the following parity groups.  

<div class="pgrow">
<div class="column">
<table style="width: 100px" class="parityGroup">    
    <caption>Group 0</caption>
    <tbody>
    <tr>
      <td class="group">0</td><td>1</td><td>1</td><td class="group">1</td>
    </tr>
    <tr>
      <td>1</td><td class="group">0</td><td class="group">0</td><td>1</td>
    </tr>
    </tbody>
</table>
</div>
<div class="column">
<table style="width: 100px" class="parityGroup">
    <caption>Group 1</caption>
    <tbody>
    <tr>
      <td>0</td><td class="group">1</td><td>1</td><td class="group">1</td>
    </tr>
    <tr>
      <td class="group">1</td><td>0</td><td class="group">0</td><td>1</td>
    </tr>
    </tbody>
</table>
</div>
<div class="column">
<table style="width: 100px" class="parityGroup">
    <caption>Group 2</caption>
    <tbody>
    <tr>
      <td>0</td><td>1</td><td class="group">1</td><td>1</td>
    </tr>
    <tr>
      <td class="group">1</td><td class="group">0</td><td class="group">0</td><td>1</td>
    </tr>
    </tbody>
</table>
</div>
<p><b>Figure 6</b>: Parity groups in 2x4 case</p>
</div>

Now let's verify that we can handle any selection the devil may make. We'll reconstruct the table from the previous exercise, omitting the group transitions for brevity.

<div class="center">
<table class="std">
<thead>
<tr>
<th>Selected Cell</th>
<th>Cell to Toggle</th>
<th>Index Bits Change</th>
</tr>
</thead>
<tbody>
<tr>
<td>0</td>
<td>3</td>
<td>011 $\rightarrow$ 000</td>
</tr>
<tr>
<td>1</td>
<td>1</td>
<td>011 $\rightarrow$ 001</td>
</tr>
<tr>
<td>2</td>
<td>0</td>
<td>011 $\rightarrow$ 010</td>
</tr>
<tr>
<td>3</td>
<td>None</td>
<td>011 $\rightarrow$ 011</td>
</tr>
<tr>
<td>4</td>
<td>6</td>
<td>011 $\rightarrow$ 100</td>
</tr>
<tr>
<td>5</td>
<td>4</td>
<td>011 $\rightarrow$ 101</td>
</tr>
<td>6</td>
<td>5</td>
<td>011 $\rightarrow$ 110</td>
</tr>
<tr>
<td>7</td>
<td>2</td>
<td>011 $\rightarrow$ 111</td>
</tr>
</tbody>
</table>
<br>
<p><b>Figure 7</b>: Cell index to toggle given devil's selection</p>
</div>
<br>

To derive this table, simply determine which index bits you'd like to change, and find that set of bits in our mapping to determine the cell index to toggle.


### Generating Parity Groups
So in the 2 previous examples we designed our own parity groups. How do we do this for an 8x8 board though? Designing the parity groups by hand for 64 bits is definitely not worth the time. So let's see what patterns we can abstract from our examples. Our magic square index is representable by an n-bit number, and we have n parity groups\*.  Each parity group maps to a single bit of our selected cell index, and those parity groups have elements that enable the toggling of any subset of our index bits. This insight is revealing: there is a combinatorial structure to our parity groups. Each element (cell index) in each parity group maps to a subset of our index bits, and toggling that cell toggles that subset of index bits. Now we simply need to generate every subset of our index bits, and map it to a group of our 64 bits. How do we generate that mapping? Subtly, it's right in front of us. From the 4x2 example we can see that simply numbering each subset with a cell index will generate this mapping, because if the number of cells on the board is a power of 2, there is exactly one cell for each subset of index bits.

<div class="center">
<table class="std">
<thead>
<tr>
<th>Dimensions</th>
<th>Index Bit Subsets</th>
<th>Parity Groups (Cell Indices)</th>
</tr>
</thead>
<tbody>
<tr>
<td>2x2</td>
<td>$\{0\},\{1\},\{0,1\}$</td>
<td>$\{0,1\},\{1,3\}$</td>
</tr>
<tr>
<td>4x2</td>
<td>$\{0\},\{1\},\{2\},\{0,1\},\{1,2\},\{0,2\},\{0,1,2\}$</td>
<td>$\{0,3,5,6\},\{1,3,4,6\},\{2,4,5,6\}$</td>
</tr>
</tbody>
</table>
<br>
<p><b>Figure 8</b>: Subsets and Parity groups from previous examples</p>
</div>
<br>

If you're familiar with the recursive structure of subsets and their relation to counting in binary, simply labeling each of our cells with their binary representation is one possible mapping of cells to parity groups. Each bit in the binary representation indicates membership in that digit's respective parity group. So cell `001` is in parity group `0`. Cell `101` is in parity group `2` and `0`. This ensures each bit has a group in which it is paired with every other subset of bits, enabling the toggling of the bit to change the exact index bit(s) that we would like to toggle.

<script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>
