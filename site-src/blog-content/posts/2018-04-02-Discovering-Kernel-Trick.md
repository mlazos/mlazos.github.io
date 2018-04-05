---
title: Discovering the Kernel Trick
---

In this post, I'll explain the motivation of the kernel trick using a minimal example.

### Introduction
Although the kernel trick can be applied to a variety of pattern recognition algorithms - essentially any that utilizes a similarity function - our focus will be on applying the kernel trick in the context of a classification problem utilizing a simple linear classifier.

### Background
If you're already familiar with the perceptron, then feel free to skip this section. 

### Motivating Example: Classifying Pressure Gauges
As a New England Patriots fan, I have in past years become acquainted with a tool that is used throughout modern sports: the pressure gauge. Let's say an NFL referee has access to two pressure gauges, one which always produces measurements with an error that is less than +/- 5 PSI and another which always produces measurements with an error that is greater than +/- 4 PSI. The referee used both to measure the air pressure of an inflated football but can't remember which measurements he took with each gauge. In order to conduct an objective investigation this information is important! (Especially to the NFL commissioner) Luckily, he still has access to the gauges and can gather some data to make an educated guess. The referee gathers some measurements and records the error. This yields the following measurements.

![__Figure 1__: Pressure Gauge Errors Recorded by Referee](/resources/gauge_errors.png){ width=80% }

So we take our linear classifier and try to train it on this data. Unfortunately, there really isn't a way to have a single linear decision boundary with this data; it's non-separable. This can be easily seen by simply looking at the data, there really isn't a way to separate the data into two halves without some significant error. Looking at the structure of the data though, we can augment our error data with an additional feature. Rather than just using the error value itself, we can add another dimension to our data, by also taking into account the square of the error value as well. Augmenting our data with our new feature results gives us the following plot.

![__Figure 2__: Pressure Gauge Errors Augmented With Squared Error](/resources/gauge_errors_augmented.png){ width=80% }

Now taking into account the squared value, the values farthest from zero will have larger second components than the values closer to zero, neatly separating our data in our artificial second dimension. So in this case, it was easy to see that creating a second component that consists of the square of the first will separate our data. So what did we actually do here? We created a $feature map$, or a function that maps our original feature space into another higher-dimensional space. So all we need to do is apply our feature map to all of our data points and then we're all set, right?

### Improving Efficiency with Kernels
So we could apply our feature map to all of our data points, but can we do this more efficiently? Let's take a closer look at our example. So right now our feature map looks like this: $\phi(x)=(x, x^2)$, and looking at the equation for the perceptron, we take a dot product between an example to be classified and all of the training examples. This dot product computation $(x, x^2) * (y, y^2)$ takes a total of 3 multiplies and an add (omitting the squaring for preprocessing), the proedure goes like this: $x*y$, $y^2$, $x^2*y^2$. We can however, reorganize the equation to eliminate redudant computation: $x*y + (x*y)^2$.  With this equation we only need to compute the product $x*y$ once, reducing the total computation to 2 multiplies and an add. As an added benefit, we can reduce the memory footpring by half by no longer preprocessing our data! This is the kernel trick, and the closed form equation we found for the dot product is known as the $kernel$. 

### Finding Valid Kernel Functions
The kernel function we found in the previous section was useful, but there are many other useful kernels. How can we determine whether a given function is a valid kernel? In the previous section, we used our domain knowledge of our data to engineer our own feature map, $\phi(x)=(x, x^2)$. To find the associated kernel $K(x,y)$, we found a closed form for the expression $\phi(x) \cdot \phi(y)$. This can always be done with any feature map that is manually defined. However, is there a way given a kernel $K$ to know whether it is a valid kernel? 
It so happens that there is a result from linear algebra called Mercer's theorem.  This theorem says that if you a have similarity function $K(x,y)$ that for any $N$ vectors

### Kernel Perceptron



### Closing Thoughts

### Extensions

* Lower the number of true joint samples we provide to the model during training, this would certainly increase the time taken to converge, but it would show off the main advantage of the model - that it can learn the joint distribution with a few paired samples.

<script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>

### Explanation of Perceptron Dual Equations
