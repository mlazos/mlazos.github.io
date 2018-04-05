---
title: Discovering the Kernel Trick
---

In this post, I'll explain the motivation of the kernel trick using a minimal example.

### Introduction
Although the kernel trick can be applied to a variety of pattern recognition algorithms - essentially any that utilizes a similarity function - our focus will be on applying the kernel trick in the context of a classification problem utilizing a simple linear classifier.

### Motivating Example: Classifying Pressure Gauges
As a New England Patriots fan, I have in past years become acquainted with a tool that is used throughout modern sports: the pressure gauge. Let's say an NFL referee has access to two pressure gauges, one which always produces measurements with an error that is less than +/- 5 PSI and another which always produces measurements with an error that is greater than +/- 4 PSI. The referee used both to measure the air pressure of an inflated football but can't remember which measurements he took with each gauge. In order to conduct an objective investigation this information is important! (Especially to the NFL commissioner) Luckily, he still has access to the gauges and can gather some data to make an educated guess. The referee gathers some measurements and records the error. This yields the following measurements.

![__Figure 1__: Pressure Gauge Errors Recorded by Referee](/resources/gauge_errors.png){ width=80% }

So we take our linear classifier and try to train it on this data. Unfortunately, there really isn't a way to have a single linear decision boundary with this data; it's non-separable. This can be easily seen by simply looking at the data, there really isn't a way to separate the data into two halves without some significant error. Looking at the structure of the data though, we can augment our error data with an additional feature. Rather than just using the error value itself, we can add another dimension to our data, by also taking into account the square of the error value as well. Augmenting our data with our new feature results gives us the following plot.

![__Figure 2__: Pressure Gauge Errors Augmented With Squared Error](/resources/gauge_errors_augmented.png){ width=80% }

Now taking into account the squared value, the values farthest from zero will have larger second components than the values closer to zero, neatly separating our data in our artificial second dimension. So in this case, it was easy to see that creating a second component that consists of the square of the first will separate our data. Now what we did might seem a little arbitrary, why can we do this?

### Finding Valid Kernel Functions
It so happens that there is a result from linear algebra called Mercer's theorem.  This theorem says that if you a have similarity function $K(x,y)$ that for any $N$ vectors

### Kernel Perceptron



### Closing Thoughts

### Extensions

* Lower the number of true joint samples we provide to the model during training, this would certainly increase the time taken to converge, but it would show off the main advantage of the model - that it can learn the joint distribution with a few paired samples.

<script src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML" type="text/javascript"></script>

### Explanation of Perceptron Dual Equations
