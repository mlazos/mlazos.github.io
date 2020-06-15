---
title: Decoding Devil's Chess
---

A few years ago one of my good friends who was local to Seattle posed to me the Devil's Chessboard puzzle. I couldn't stop thinking about the puzzle day and night. It took me until now to *fully understand* this puzzle and have a full solution that I devised on my own.

### The Problem
You and your friend have been trapped in the underworld, but the devil, as merciful as he is decides he will let you go if you can solve his most devious trick! He whips out an 8x8 chessboard and places quarters over the entire board randomly. He orders your friend to leave the room. Once your friend has left the devil turns to you and says HERE IS THE MAGIC SQUARE and points to a square on the board. Now you must communicate to your friend which square is the magic square by flipping at most one coin. No other communication can be made. The devil, being as fair as he is, allows you to speak to your friend to strategize before making your friend leave the room. Once you have flipped at most one coin (or flipped no coin at all) you leave the room and your friend is invited back in to reveal which square is the magic square.

### Initial Impression
Let's try to come up with some ballpark ideas to try and find a pattern in the problem. Maybe we can us the rows and columns to communicate the row an column of the square in binary? We are dealing with heads and tails here but we're limited to only change at most one bit. Let's see if we can reduce this problem down to its essence.

### Smaller Boards!
Going with binary seems to be a good way to think about the problem, so let's try and make the problem small, really really small. A 2x2 board seems easy enough.

So funamentally, flipping a coin is equivalent to flipping a bit in our binary representation of four bits. And that's when I realized parity could provide some useful information. This makes sense because flipping a coin changes the parity of the board, and since we are explicitly given the option not to flip as well, this gives us a hint that the board could happen to be in the correct configuration already. With this small board it started to come together, if I flip any cell, the parity of the row and column of that cell change, but other rows and columns will remain unchanged. This made me think, I don't need to stick to using  the rows and columns of this board, I can make any grouping I want, let's call these *parity groups.*

So in this small example we designed our own parity groups. How do we do this for an 8x8 board though? Designing the parity groups by hand for 64 bits is definitely not worth the time. So let's see what patterns we can abstract from our small example. Our magic square index is represenatble by a two-bit number, and we have two parity groups\*.  Our coin flip, based on the cell we choose, can flip either the 0th bit, the 1st bit, *both* or *none at all*. This insight is revealing: there is a combinatorial structure to our parity groups. Each group is mapped to a subset of our magic square index bits. So for our 4 cell board, we have an empty group, where if we choose to change the parity of that group, no bits of magic square index bits change. For each parity group we need to be able change a subset of the magic square index bits. Since in this problem, the devil's configuration is random, and any cell can be chosen, we need to have parity group for every subset of the index bits, because we may need to change any number of those bits to arrive at our correct index. Let's go back to our 8x8 problem. Here we have 64 cells, which requires 6 index bits to represent our magic square index. Now we simply need to generate every subset of our index bits, and map it to a group of our 64 bits. 

\* Technically three, but I am excluding the empty group.
