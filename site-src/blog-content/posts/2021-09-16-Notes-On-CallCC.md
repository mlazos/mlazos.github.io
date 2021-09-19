---
title: Notes on CallCC
---
### Introduction and Background
These are my notes detailing my intuition of `callCC` (call-with-current-continuation) after reading through the [continuation passing style chapter](https://en.wikibooks.org/wiki/Haskell/Continuation_passing_style) of the Haskell wikibook. `callCC` is a control operator which enables explicit manipulation of a program's control flow. In this post we will focus on the Haskell implementation - the [continuation monad](https://en.wikibooks.org/wiki/Haskell/Continuation_passing_style), and provide some additional details not covered in the wikibooks chapter.

### CallCC in Haskell
In Haskell, `callCC` is provided through the `Cont` monad.  This monad enables computations to be transformed to/from [continuation passing style](https://en.wikibooks.org/wiki/Haskell/Continuation_passing_style). This doesn't enable much on its own, because the explicit control flow manipulation enabled by CPS is not exposed through the typical bind and return operators of the monad - these just enable construction and composition of a computation chain in CPS form. `callCC` however enables the programmer to explicitly manipulate this control flow, by binding the current continuation to an identifier and enabling the programmer to call this continuation anywhere in the program. To begin our investigation of `callCC` first let's understand the relevant details of the `Cont` monad. The type signatures of the wrapper and unwrapper functions are important, because we will use them to access the relevant continuations in our implementation of `callCC`. Additionally the monadic bind shows how we apply a CPS function to a chain of suspended computations.

```haskell
-- A possible definition for Cont r a, record syntax defines a getter runCont :: Cont r a -> (a -> r) ->  r
-- which can be used to extract a CPS function from a CPS computation
newtype Cont r a = Cont { runCont :: (a -> r) -> r }

-- Create a CPS computation from a CPS function, the inverse of runCont
-- Cont r a describes a computation which needs a continuation of type (a -> r) to conclude and return an r
cont :: ((a -> r) -> r) -> Cont r a 
cont f = Cont \k -> f k -- k is the next continuation in the chain

-- Monadic bind provides a way of extending the computation chain with a CPS function
instance Monad (Cont r) where
return x = cont ($ x)
s >>= f = cont $ \c -> runCont s $ \x -> runCont (f x) c -- Note: s is a suspended computation to be augmented with f
```

Now let's form our intuition before implementating the function. We know fundamentally that `callCC` takes a function `f` and provides the current continuation through a bound identifier within the scope of `f`. We also know that calling this continuation breaks the current computation chain, and jumps to the body of this continuation. The steps we need then, are the following:

1. Name the current continuation
2. Construct a new continuation which will unconditionally call the current continuation (ignoring the next continuation in the chain)
3. Provide this continuation as a function to `f` so that it can call it where desired to break out of the current chain of suspended computations
4. Ensure the current continuation will be called even if `f` doesn't call the provided breaking function

Step 4 is important to note, because the programmer also has the option of not calling the provided continuation, and continuing through the unmodified suspended computation chain. Now that we know the steps, let's start implementing them, using the types to check our intuition. So with step 1, we need to access the current continuation. We know how to do this from the type signature of a CPS function, and from the CPS monadic bind. The current continuation is the `(a -> r)` argument of a CPS function. This argument has not been provided yet, since each `Cont r a`, represents a suspended computation, which will complete when given a continuation.

```haskell
callCC f = cont $ \h -> ... 
```
This gives us access to the current continuation, `h`, which will be populated by either the next continuation in the chain, or by the continuation provided by `runCont`. This follows exactly the pattern from the monadic bind.

Now in step 2, we should create another continuation that will unconditionally call h, ignoring its provided continuation argument (the break in the chain that we alluded to above).

```haskell
callCC f = cont $ \h -> ... cont $ \_ -> h ...
```

Now, we know that the type of h is `(a -> r)` so we need to provide it with an argument. Where does this argument come from? Its caller, and we know that the "break in the chain" is called from within `f`.

```haskell
callCC f = cont $ \h -> ... f (\x -> cont $ \_ -> h x) ...
```

As we mentioned previously `f` can either call or not call the breaking function. However, `f` must return the same type in both cases, namely `Cont r a`. From here, we need to ensure we pass `h` onto the continuation returned by `f`. 

```haskell
callCC f = cont $ \h -> runCont f (\x -> cont $ \_ -> h x) h
```

This is our final implementation. In essence, we provide `h` to `f` through a function which will unconditionally call `h`, and if `f` does not call that function, the outer `runCont` will provide `h` as the next continuation after the continuation chain within `f` has completed. Now that we have a full implementation, let's analyze its type.

```haskell
callCC :: ((a -> Cont r b) -> Cont r a) -> Cont r a
```

This type looks complex, but on closer examination, it is not unexpected from what we know of our implementation steps. First, the return value of `Cont r a` is exactly as we expect, since `callCC` returns a newly created `Cont r a`. The type of `f` is `((a -> Cont r b) -> Cont r a)` indicating that `f` takes a function `(a -> Cont r b)` (our function to beak the continuation chain) and returns a `Cont r a`. What is interesting here is that `b` is an arbitrary type. This stems from the return type of `(\x -> cont $ \_ -> h x)`.  Since the continuation which is returned ignores its argument and unconditionally invokes `h`, and because the `b` in `Cont r b` represents the argument type of the continuation, this type `b` is not constrained.

### Extensions
- Implement `callCC` without using monads (hint: take a look at `chainCPS` in the wikibook chapter)
- What happens if the breaking function is called later in a computation (for instance by storing it in the `Reader` monad)
- What are the performance implications of a function like `callCC`? 

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