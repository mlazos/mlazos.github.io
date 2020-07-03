---
title: Decoding Devil's Chess
---

<style>
table.parityGroup {
  border: 1px solid #000000;
  background-color: #FFFF;
  width: 60px;
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
.center {
  margin: auto;
  width: 300px;
  padding: 20px;
  text-align: center;
</style>


A few years ago one of my good friends who was local to Seattle posed to me the Devil's Chessboard puzzle. I couldn't stop thinking about the puzzle day and night. It took me until now to *fully understand* this puzzle and have a full solution that I devised on my own.

### The Problem
You and your friend have been trapped in the underworld, but the devil, as merciful as he is decides he will let you go if you can solve his most devious trick! He whips out an 8x8 chessboard and places quarters over the entire board randomly. He orders your friend to leave the room. Once your friend has left the devil turns to you and says HERE IS THE MAGIC SQUARE and points to a square on the board. Now you must communicate to your friend which square is the magic square by flipping at most one coin. No other communication can be made. The devil, being as fair as he is, allows you to speak to your friend to strategize before making your friend leave the room. Once you have flipped at most one coin (or flipped no coin at all) you leave the room and your friend is invited back in to reveal which square is the magic square.

### Initial Impression
Let's try to come up with some ballpark ideas to try and find a pattern in the problem. Maybe we can us the rows and columns to communicate the row an column of the square in binary? We are dealing with heads and tails here but we're limited to only change at most one bit. Let's see if we can reduce this problem down to a form with an obvious solution.

### Let's Solve a Simpler Problem ...
Going with binary seems to be a good way to think about the problem, so let's try and make the problem small, really really small. A 2x2 board seems easy enough.

At a fundamental level, flipping a coin is equivalent to flipping a bit in our board's binary representation of four bits. This by definition changes the parity of a specific row and column but nothing else. We're on the right track here because flipping a coin changes the parity of the board, and since we are explicitly given the option not to flip as well, this gives us a hint that the board could happen to be in the correct configuration already. So how do we use parity to indicate an arbitrary cell? If we number the cells from 0-3 (shown below), we can represent all of those values with a 2 bit integer, we'll call these our index bits. 

<div class="pgrow">
<div class="column">
<table class="parityGroup">    
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


Then again why do we need to map to a row and column of the board? Why not create any two arbitrary groups with a single overlapping cell? This approach does indeed work and is much more flexible.  

### Generating Parity Groups
So in the 2x2 example we designed our own parity groups. How do we do this for an 8x8 board though? Designing the parity groups by hand for 64 bits is definitely not worth the time. So let's see what patterns we can abstract from our small example. Our magic square index is representable by a 2-bit number, and we have 3 parity groups\*.  This insight is revealing: there is a combinatorial structure to our parity groups. Each group is mapped to a subset of our magic square index bits. So for our 4 cell board, we have an empty group, where if we choose to change the parity of that group, no bits of magic square index bits change. For each parity group we need to be able change a subset of the magic square index bits. Since in this problem, the devil's configuration is random, and any cell can be chosen, we need to have parity group for every subset of the index bits, because we may need to change any number of those bits to arrive at our correct index. Let's go back to our 8x8 problem. Here we have 64 cells, which requires 6 index bits to represent our magic square index. 


Now we simply need to generate every subset of our index bits, and map it to a group of our 64 bits. How do we generate that mapping? Subtly, it's right in front of us. If you're familiar with the recursive structure of subsets and their relation to counting in binary, simply labeling each of our cells with their binary representation is one possible mapping of cells to parity groups. Each bit in the binary representation indicates membership in that digit's respective parity group. So cell `001` is in parity group `0`. Cell `101` is in parity group `2` and `0`. This ensures each bit has a group in which it is paired with every other subset of bits, enabling the toggling of the bit to change the exact index bit(s) that we would like to toggle.

000
001
011
010
110
111
101
100

\* Technically three, but I am excluding the empty group.