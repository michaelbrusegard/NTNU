package part3;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

/**
 * Implementation of CharCounter that accepts only letters,
 * based on the corresponding method in Character.
 */

public class CharCounterImpl2 implements CharCounter {

	private Collection<Character> acceptedChars = new ArrayList<>(Arrays.asList('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
			'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'));

	private List<Character> counterType = new ArrayList<>(27);
	private List<Integer> counterAmount = new ArrayList<>(27);

	@Override
	public boolean acceptsChar(final char c) {
		if (acceptedChars.contains(Character.toLowerCase(c)))
			return true;
		return false;
	}

	@Override
	public void countChar(final char c, final int increment) throws IllegalArgumentException {
		if (!acceptsChar(c)) {
			throw new IllegalArgumentException("Count of '" + c + "' is not supported");
		}
		if (increment < 1) {
			throw new IllegalArgumentException("Increment must be >= 1");
		}
		int index = counterType.indexOf(c);
		if (index != -1) {
			counterAmount.add(index, counterAmount.get(index) + increment);
		} else {
			counterType.add(c);
			int i = counterType.indexOf(c);
			counterAmount.add(i, increment);
		}
	}

	@Override
	public Collection<Character> getCountedChars() {
		return counterType;
	}

	@Override
	public int getCharCount(final char c) {
		int result;
		int index = counterType.indexOf(c);
		if (index != -1)
			result = counterAmount.get(index);
		else
			result = 0;
		return result;
	}

	@Override
	public int getTotalCharCount() {
		return counterAmount.stream().reduce(0, Integer::sum);
	}

	public static void main(String[] args) {

		final CharCounterImpl2 counter = new CharCounterImpl2();
		System.out.println(counter.acceptsChar('A')); // true
		System.out.println(counter.acceptsChar('1')); // false
		counter.countChar('A', 2);
		counter.countChar('B', 3);
		System.out.println(counter.getCharCount('A')); // 2
		System.out.println(counter.getTotalCharCount()); // 5
		System.out.println(counter.getCountedChars()); // [A, B]
	}

}
