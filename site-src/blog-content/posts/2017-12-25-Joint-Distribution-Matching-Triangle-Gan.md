---
title: Cross-Domain Distribution Matching with Triangle GANs
---

This is a tutorial on implementing [Triangle Generative Adversarial Networks](https://papers.nips.cc/paper/7109-triangle-generative-adversarial-networks) from NIPS 2017. This is useful as a deep learning exercise in tensorflow while also learning about some of the newest research in generative adversarial models.

### Motivation and Background
Cross-Domain joint distribution matching is the problem of taking samples from two domains, like text and images, and learning a joint distribution over them.  The intuition here is that we would like to learn a mapping that matches samples from one domain to samples of the other. An example of this is attribute-conditional image generation, where given some attributes of an image, we want to generate a random image with those attributes. This is easily achievable if fully paired data is available, but often a fully labeled dataset is difficult to gather. There are multiple proposed solutions to this, including many fully unsupervised methods. These however have an important drawback, mainly that without any label information the learned mapping between the domains may not be the desired one - for instance, the model may learn that the attribute 'man' maps to a child image as long as the discriminator agrees. To solve this problem, triangle-GAN uses a few paired samples to inform the discriminators what kind of mapping is desired. 

### Triangle GAN Architecture
The Triangle GAN consists of two generators and two discriminators. The generators learn the two conditional distributions between the domains, while one discriminator learns to distinguish between real and fake samples and the second discriminator learns to distinguish between the different fake samples. This is a really elegant way of forcing the generators to approximate the data distribution: the first discriminator ensures that both generators generate real-looking samples and the second discriminator ensures that the two distributions defined by the generators generate similar samples.

### Implementation
First let's build some helper functions to create the different components of the model. What we'll need is a multi-layer feedforward network - this will be the basic building block of the generators and discriminators.
```python
    # for each layer create a weight matrix and bias vector
    for i in range(0, num_hidden_layers):
        with tf.variable_scope("dense" + str(i)):
            w_n = tf.get_variable(
                "w_" + str(i), 
                [prev_input_dim, hidden_dim], initializer=tf.initializers.random_normal(0, 1))
            b_n = tf.get_variable(
                "b_" + str(i), 
                [hidden_dim], 
                initializer=tf.initializers.random_normal(0, 1))
            prev_input_dim = hidden_dim
            prev_output = hidden_activation(
                tf.matmul(prev_output, w_n) + b_n)
    with tf.variable_scope("dense_output"):
        return tf.layers.dense(
                prev_output, 
                output_dim, 
                activation=output_activation)
```
This code creates a weight matrix and bias vector for each hidden layer, one for the output layer, and allows the caller to specify the input, hidden, and output dimension, along with the activations for the hidden and output layers.  Next, let's set some of these parameters for our generators and discriminators.

### Generating Fake Data
Using the components we've implemented, we're now going to build the generative portion of the model. In order to sample from the conditional ditribution we'll need a function that takes two inputs 1) some noise and 2) a sample from the other domain. The noise can be thought of as a source of randomness and the sample as the value of the variable we are conditioning on. To model this function we'll use a feedforward neural network which learns how to transform the sample from the noise distribution into samples from the conditional distribution. In code:

```python
def generator(input):
    return feedforward(input, 3, num_units_gen, 1, num_layers_gen, hidden_activation)

with tf.variable_scope("generator_xy"):
    x_given_y = generator(z_y_samples)

with tf.variable_scope("generator_yx"):
    y_given_x = generator(x_z_samples)

fake_x_pairs = tf.concat((x_given_y, y_samples_e), 1)
fake_y_pairs = tf.concat((x_samples_e, y_given_x), 1)
```
Here we create a scope for each generator. The network in the `generator_xy` scope generates a sample from domain x given two noise samples and a sample from domain y, while the network in the `generator_yx` scope generates a sample from domain y given two noise samples and a sample from domain x.

### The Discriminators
Our discriminators are modeled by simple feedforward networks as well:
```python
def discriminator(input):
    return feedforward(input, 2, num_units_disc, 1, num_layers_disc, hidden_activation, tf.nn.sigmoid)

with tf.variable_scope("disc_real_or_fake") as d_rf_scope:
    fake_x_scores_drf = discriminator(fake_x_pairs)
    d_rf_scope.reuse_variables()
    real_scores_drf = discriminator(joint_samples)
    fake_y_scores_drf = discriminator(fake_y_pairs)

with tf.variable_scope("disc_fake_x_or_fake_y") as d_fxfy_scope:
    fake_x_scores_dfxfy = discriminator(fake_x_pairs)
    d_fxfy_scope.reuse_variables()
    fake_y_scores_dfxfy = discriminator(fake_y_pairs)
```
We organize our code into two scopes, ```disc_real_fake``` for our real vs. fake discriminator and ```disc_fake_x_or_fake_y``` for our discriminator of fake sample types. This keeps our code nicely organized, and will also allow us to easily select which variables we want to train during adversarial learning. It's important to notice that we only compute scores for  `disc_fake_x_or_fake_y` on *fake* samples, and completely ignore *real* samples.   

### Minimizing the Discriminator Loss
The objective of the discriminators is to 1) distinguish between real and fake samples and 2) distinguish between the two kinds of fake samples. Using this as a blueprint, `disc_real_fake`'s loss is designed to have the network learn to classify the real pairs as `1` and either of the fake pairs as `0`.
```python
loss_real_fake_disc = tf.losses.log_loss(ZEROS, fake_x_scores_drf) \
    + tf.losses.log_loss(ONES, real_scores_drf) \
    + tf.losses.log_loss(ZEROS, fake_y_scores_drf)
```
Similarly, the loss of `disc_fake_x_or_fake_y` is designed to coerce the network to classify pairs with a fake y component as `1` and classify pairs with a fake x component as `0`:
```python
loss_fake_x_fake_y_disc = tf.losses.log_loss(ONES, fake_y_scores_dfxfy) \
    + tf.losses.log_loss(ZEROS, fake_x_scores_dfxfy)
```
The total loss is simply the sum of the two discriminator losses. A training step consists of a gradient computation with respect to the discriminator variables, and then perturbing the network's weights in a direction which allows the two discriminators to minimize the total loss. This operation is encapsulated in the `minimize` method of the built in `AdamOptimizer`. The learning rate of `0.0025` was chosen because the results looked sharper. Experimenting with different learning rates and a longer training time might give better results. This was optimized to give faster results. 
```python
loss_discriminators = loss_real_fake_disc + loss_fake_x_fake_y_disc

train_step_discriminators = tf.train.AdamOptimizer(learning_rate=0.0025).minimize(loss_discriminators, var_list=discriminator_vars)
```

### Minimizing the Generator Loss
The goal of the generators is to generate samples that are indistinguishable from real samples. In essence, we design the generator losses so that minimizing the generator loss *maximizes* the discriminator loss. Formally, we have the generators learn to generate samples that result in discriminator scores closer to the label *opposite* to the label specified in the discriminator objective. In code: 
```python
loss_gen_x_y = tf.losses.log_loss(ONES, fake_x_scores_drf) \
    + tf.losses.log_loss(ONES, fake_x_scores_dfxfy)

loss_gen_y_x = tf.losses.log_loss(ONES, fake_y_scores_drf) \
    + tf.losses.log_loss(ZEROS, fake_y_scores_dfxfy)

loss_generators = loss_gen_x_y + loss_gen_y_x

train_step_generators = tf.train.AdamOptimizer(learning_rate=0.0025).minimize(loss_generators, var_list=generator_vars)
```
The losses here show how the generator objective is the inverse of the discriminator objective. We coerce `fake_x_scores_drf`, `fake_x_scores_dfxfy`, and `fake_y_scores_drf` to the label `1` and `fake_y_scores_dfxfy` to label `0`, the exact opposite of the labels in the discriminator loss. We once again use the `AdamOptimizer` to minimize the generator loss with respect to the generator variables.

### Training Procedure
Now the final step is generate our samples and train both the discriminators and the generators simultaneously. The data distribution we are trying to approximate is a mixture of 4 bivariate gaussians with means and variances described in the [paper](https://papers.nips.cc/paper/7109-triangle-generative-adversarial-networks) and our noise distribution is a guassian with mean 0 and variance 10. The higher variance is useful to make sure the noise distribution's support is a superset of the support of the distribution we are trying to sample from. This is a small optimization that means the generator network no longer needs to learn stretch the space of the noise distribution to match the sample space of the data distribution. This speeds up training time because the network has fewer properties that it needs to learn.  We adopt a simplified training procedure to get faster results on my modest 2.6GHz laptop CPU. First we sample 1000 pairs from our data distribution. 500 act as supervised labeled pairs and 500 act as our independent x and y samples to provide to the generators to generate the fake x and fake y samples. We then pass the data to the respective training steps for the discriminator and generator. We iterate through this process 1000 times.

```python
for i in range(0, 1000):
    joint_input = generate_samples(125)

    np.random.shuffle(joint_input)

    temp_input = generate_samples(125)
    
    np.random.shuffle(temp_input)
    x_input = temp_input[:, 0]
    np.random.shuffle(temp_input)
    y_input = temp_input[:, 1]
    z_input = np.random.multivariate_normal([0,0], [[10.0, 10.0], [10.0, 10.0]], 4 * 125)

    for _ in range(0, 9):
        train_step_discriminators.run({x_samples:x_input, joint_samples:joint_input, y_samples:y_input, z_samples: z_input})
    
    train_step_generators.run({x_samples:x_input, joint_samples:joint_input, y_samples:y_input, z_samples: z_input})
```
You may notice that we run the discriminator training step 10 times for each generator training step. This has been [shown](https://papers.nips.cc/paper/5423-generative-adversarial-nets.pdf) to have better convergence properties and avoids the scenario where the generators learn to fool the discriminator by "playing it safe" and generating less diverse samples, i.e. mapping many samples of the noise distribution to the same value of the conditional distribution. By training the discriminator more, we allow the discriminator to better generalize and accept more diverse samples. In our case though, this is more to allow the networks to converge faster. If the discriminators converge faster, the faster the generators can learn how to fool them.

### Closing Thoughts
I was pretty surprised at how sensitive this GAN is to its hyperparameters. Even small adjustments to the learning rate can dramatically alter the final distributions. Another surprise for me was how much more effective using tanh vs leaky relu was for these networks. I suspect this is due to the dying relu problem, because the learning rate is set pretty high in order to get faster convergence. This could be a good exercise to investigate Tensorflow internals, but I haven't had time to investigate further. 

### Extensions
