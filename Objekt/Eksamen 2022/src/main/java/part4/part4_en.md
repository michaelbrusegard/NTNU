# Part 4 - CharCounter and file handling (25%)

This part combines *CharCounter** and file handling.

In part A, you are to define a text-based file format for **CharCounter** and implement saving of this format. 

In part B, you are to count characters of text stored in files.

## Part A)

Implement saving to file for **CharCounter** by implementing **CharCounterFileFormat**
(see [CharCounterFileFormat](CharCounterFileFormat.java) in class **CharCounterFileFormatImpl**.

The file format is to be text based, and ideally, general enough to handle counting of any type of character, also blanks and linebreaks. Write documentation of your format as javadoc text at the top of the class, and make an example text file [CharCounterFileFormat-sample.txt](CharCounterFileFormat-sample.txt)  illustrating the format.

Implement the necessary methods:

- **save(CharCounter, OutputStream)** - writes the contents of the CharCounter arguemnt to the OutputStream argument, in accordance with the format you have defined. What is written is to be read by the load methods. 
- **CharCounter load(InputStream)** - creates a CharCounterImpl instance with content read from the InputStream argument in accordance with the format you have defined.

Text saved by the save method of one CharCounter instance, shall give an equivalent CharCounter instance by when we use the load method with the same text.  

- **void loadInto(CharCounter charCounter, InputStream)** - extends an existing CharCounter instance with content read from the InputStream argument, in accordance with the text format. 

## Oppgave B)

Implement the methods of **CharCounterUtil** in [CharCounterUtil.java](CharCounterUtil.java)

- **CharCounter countLetters(File)** - counts the characters in the File argument 
- **computeDistance(CharCounter, CharCounter)** - measures the "distance" between to CharCounter instances, defined in the following way:
   - calculating the *relative frequency* of each character (the count of the character, divided by the total number of characters) for each CharCounter instance.
   - for each character, take the difference of the relative frequencies for each CharCounter instance.
   - sum over all the characters, the squares of the differences 

For example, if one CharCounter counts 2 A's, and 3 B's (and no C's), and the other counts 2 B's and 1 C, (but no A's), we get the following calculations:
- relative frequencies for A, B and C: $\frac25, \frac35, \frac05$ and $\frac03, \frac23, \frac13$
- The distance is then given by
  $$\left(\frac25-\frac03\right)^2 + \left(\frac35 - \frac23\right)^2 + \left(\frac05-\frac13\right)^2$$
  Do the calculation by using floating points numbers.

- **unmodifiableCharCounter(CharCounter)** - returns an instance of a class that implements CharCounter, which delegates to the argument, but throws an exception for methods that attempt to modify it. 
