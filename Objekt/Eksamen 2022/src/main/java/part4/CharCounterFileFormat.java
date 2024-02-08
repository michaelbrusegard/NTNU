package part4;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import part3.CharCounter;
import part3.CharCounterImpl;

/**
 * Handles reading and writing of CharCounter.
 *
 */
public interface CharCounterFileFormat {

	/**
	 * Write a CharCounter to an OutputStream.
	 *
	 * @param cc the CharCounter to write
	 * @param out the OutputStream to write to
	 * @throws IOException if something goes wrong
	 */
	public void save(final CharCounter cc, final OutputStream out) throws IOException;

	/**
	 * Loads and returns a CharCounterImpl from an InputStream.
	 * The format must correspond to that written by the save method.
	 * The new CharCounterImpl should only accept those characters that have previously been counted.
	 *
	 * @param in InputStream to read from
	 * @return a new CharCounterImpl
	 * @throws IOException if something goes wrong or the format is incorrect
	 */
	public CharCounterImpl load(final InputStream in) throws IOException;

	/**
	 * Loads CharCounter data from an InputStream into into existing CharCounter.
	 * The format must correspond to that written by the save method.
	 * The existing CharCounter needs to accept all characters that have previously been counted.
	 *
	 * @param charCounter the CharCounter to read into
	 * @param in the InputStream to read from
	 * @throws IOException if something goes wrong, the format is incorrect or CharCounter doesn't accept all the characters.
	 */
	public void loadInto(CharCounter charCounter, final InputStream in) throws IOException;
}
