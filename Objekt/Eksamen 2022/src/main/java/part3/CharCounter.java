package part3;

import java.util.Collection;

/**
 * Functionality for counting characters from some source
 *
 */
public interface CharCounter {

	/**
	 * Tells whether a character is supported for counting.
	 *
	 * @param c the character to check
	 * @return true if this character can be counted, false if not
	 */
	boolean acceptsChar(char c);

	/**
	 * Adds another char to the set counted so far.
	 *
	 * @param c the character to count
	 * @throws IllegalArgumentException if the character cannot be counted according to acceptsChar,
	 * or the increment is zero or negative
	 */
	void countChar(char c, int increment) throws IllegalArgumentException;

	/**
	 * Utility method for counting one occurrence of c
	 * @param c the char to count
	 */
	default void countChar(final char c) {
		countChar(c, 1);
	}

	/**
	 * Get a collection of characters counted so far,
	 * i.e. that will return more than 0 as the count.
	 * Modifying this collection should not modify the original.
	 *
	 * @return a collection of counted characters
	 */
	Collection<Character> getCountedChars();

	/**
	 * Gets the current count for c.
	 *
	 * @param c the char to get the count for
	 * @return the current count for c
	 */
	int getCharCount(char c);

	/**
	 * Gets the total number of characters counted,
	 * i.e. the sum of all the counters.
	 *
	 * @return the total number of characters counted
	 */
	int getTotalCharCount();
}
