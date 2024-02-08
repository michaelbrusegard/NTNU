# Part 2 (25%)

## Task A)

The class [**DecreasingStack**](DecreasingStacks.java) implements a *stack* of integers, but with the extra
condition that an element can only be pushed (added to the stack) if it is *smaller than" all elements currently in the stack.

You are to implement the following methods:

- isEmpty(): returns true if stack is empty
- push(int n): adds n as top element, but only if it is smaller than elements already in the stack
- peek(): returns the top (last pushed) element, but does not change the stack
- pop(): as peek(), but top element is removed from stack.

In addition, implement a constructor and a **toString()** method.

For more details, see javadoc.

## Task B)

The class [**DecreasingStacks**](DecreasingStacks.java) also works similar to a stack, but uses a collection of **DecreasingStack** in its implementation.

Complete the implementations of the following methods:

- isEmpty(): returns true if there are no elements in DecreasingStacks.
- push(int n): pushes n to the first **DecreasingStack** in its collection, that accepts n. If none accept it, create a new **DecreasingStack** and push n to it.
- pop(): returns and removes the smallest element currently in **DecreasingStacks**
- popAll(): returns a list of all elements in increasing order. 

For more details, see javadoc.

## Task C)

Write a test class for **DecreasingStack**, testing **push** and **pop** methods (and implicitly, on or more other methods.) This class is located in the test directory.
