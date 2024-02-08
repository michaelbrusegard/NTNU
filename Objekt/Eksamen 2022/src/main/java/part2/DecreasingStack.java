package part2;

import java.util.ArrayList;
import java.util.List;

/**
 * A stack of integers that is decreasing in size.
 */
public class DecreasingStack {

	public List<Integer> stack;

	/**
	 * Initializes this DecreasingStack with the provided element.
	 */
	public DecreasingStack(final int firstValue) {
		this.stack = new ArrayList<>();
		this.stack.add(firstValue);
	}

	/**
	 * Pushed the provided element at the top, but
	 * only if it is less than the current topmost element.
	 *
	 * @param element to be pushed
	 * @return true if element is successfully pushed, false otherwise
	 */
	public boolean push(final int element) {
		for (Integer item : stack) {
			if (element > item)
				return false;
		}
		stack.add(element);
		return true;
	}

	/**
	 * Removes and return the topmost element (if any)
	 *
	 * @return the optmost element (if any)
	 * @throws an appropriate subclass of RuntimeException if is stack is empty.
	 */
	public int pop() {
		if (stack.isEmpty())
			throw new IndexOutOfBoundsException("stack is empty");
		int topmostEl = stack.remove(stack.size() - 1);
		return topmostEl;
	}

	/**
	 * Returns the topmost element (if any).
	 *
	 * @return top element of the stack (if any), or null if it is empty
	 * @throws an appropriate subclass of RuntimeException if is stack is empty.
	 */
	public int peek() {
		if (stack.isEmpty())
			throw new IndexOutOfBoundsException("stack is empty");
		int topmostEl = stack.get(stack.size() - 1);
		return topmostEl;
	}

	@Override
	public String toString() {
		String result = "";
		for (int element : stack) {
			result += Integer.toString(element) + ",";
		}
		result = result.substring(0, result.length() - 1);
		return result;
	}

	/**
	 * @return true if stack is empty, false otherwise
	 */
	public boolean isEmpty() {
		return stack.isEmpty();
	}

	// for your own use

	public static void main(final String[] args) {
		final DecreasingStack ds = new DecreasingStack(10);
		ds.push(6);
		ds.push(3);
		System.out.println(ds);

		if (ds.push(5)) {
			System.out.println("Pushed 5");
		} else {
			System.out.println("Cannot push 5");
		}

		while (!ds.isEmpty()) {
			System.out.println(ds.pop());
		}

		// throws exception
		ds.peek();
	}
}
