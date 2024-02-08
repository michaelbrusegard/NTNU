package part4;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import part3.CharCounter;
import part3.CharCounterImpl;

/**
 * TODO: Document the file format here
 */
public class CharCounterFileFormatImpl implements CharCounterFileFormat {

	@Override
	public void save(final CharCounter cc, final OutputStream out) {
		// TODO
	}

	@Override
	public CharCounterImpl load(final InputStream in) throws IOException {
		// TODO
		return null;
	}

	@Override
	public void loadInto(final CharCounter cc, final InputStream in) throws IOException {
		// TODO
	}
}
