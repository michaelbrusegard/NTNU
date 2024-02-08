package part4;

import java.io.File;
import java.io.IOException;

import part3.CharCounter;

public class CharCounterUtil {

	/**
	 * Counts the letters in the provided File.
	 * The returned CharCounter accepts only letters.
	 *
	 * @param file the file to read
	 * @return the CharCounter with letter counts
	 * @throws IOException if reading goes wrong
	 */
	public static CharCounter countLetters(final File file) throws IOException {
		// TODO
		return null;
	}

	/**
	 * Computes a measure of distance between character frequencies.
	 * This is useful for guessing the language in a fragment of text.
	 * For each of the counted characters, sum the square of difference in frequency.
	 * The frequency of a char c in a CharCounter cc,
	 * is the count of c in cc divided by total char count in cc.
	 *
	 * @param cc1
	 * @param cc2
	 * @return
	 */
	public static double computeDistance(final CharCounter cc1, final CharCounter cc2) {
		// TODO
		return 0.0;
	}

	/**
	 * Returns an unmodifiable CharCounter that is a view of the CharCounter-argument.
	 * Query/read operations on the returned CharCounter "read through"
	 * to the specified CharCounter, and attempts to modify the returned
	 * CharCounter result in an UnsupportedOperationException.
	 *
	 * @param the CharCounter for which an unmodifiable view is to be returned
	 * @return the unmodifiable view of the specified CharCounter
	 */
	public static CharCounter unmodifiableCharCounter(final CharCounter delegate) {
		// TODO
		return null;
	}
}
