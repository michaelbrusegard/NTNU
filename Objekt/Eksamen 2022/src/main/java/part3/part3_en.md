# Part 3: CharCounter, CharCounterImpl og CharCounterImpl2 (20%)

This task is about counting occurrences of characters, that can be used for e.g. classifying text. 
The interface **CharCounter** (see [CharCounter](CharCounter.java)) covers the most central methods for this, and in this part you are to implement the interface, togheter with som *convenience methods* (methods that are useful to have).

To avoid problems with consequential errors of the interface methods that you may make, you are first to implement the convenience methods of **CharCounterImpl** in part A). Here, the inteface methods are already correclty implemented via a **Map/HashMap**. 

In part B), you are to make your own implementations in **CharCounterImpl2** of the interface methods (see [CharCounterImpl2](CharCounterImpl2.java)). Here, you are **not** allowed to use **Map/HashMap**, but must use other techniques/classes to achieve the same.

## Part A)

Complete [CharCounterImpl](CharCounterImpl.java), implementing the constructiors and the following methods:

- **add(CharCounter)** - adds all the counters from the argument, to this CharCounter instance.
- **getCountedCharsAsString()** - returns all counted characters as a String.
- **getCharCountIgnoreCase(char)** - similar to getCharCount, but combines counters for lower- and upper case of the same letter.
- **getCharCount(Predicate)** - returns the sum of all counters for characters satisfying the Predicate argument.
- **countChars(String)** - counts characters (that are supported) of the String argument. 
- **countChars(Iterator)** - counts characters (that are supported) given by the Iterator argument. 
- **countChars(Iterable)** - counts characters (that are supported) given by the Iterable argumentet
- **countChars(Stream)** - counts characters (that are supported) given by the Stream argumentet
- **countChars(Reader)** - counts characters (that are supported) given by the Reader argumentet
- **countChars(InputStream)** - counts characters (that are supported) given by the InputStream argumentet

For details, see the javadoc given.

## Oppgave B)

Complete the implementation of the interface methods in [CharCounterImpl2](CharCounterImpl2.java):

- **acceptsChar(char)** - determines which characters that are supported. Only letters are to be supported. 
- **countChar(char, int)** - increments the counter for character by the given integer. Throws an exception if the character is not supported. 
- **getCountedChars()** - returns the set of characters that are counted **so far**. 
- **getCharCount(c)** - returns the counter for the given character. 
- **getTotalCharCount()** - returns the sum of all the counters.

For more details of the behavior, see javadoc in the files.
