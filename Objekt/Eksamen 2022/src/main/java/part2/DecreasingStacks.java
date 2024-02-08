package part2;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.List;

/**
 * DecreasingStacks is a class that manages an ordered list of
 * {@link DecreasingStack} instances
 * None of the stacks are allowed to be empty.
 */
public class DecreasingStacks {

	Collection<DecreasingStack> stacks = new ArrayList<>();

	/**
	 * @return true if all stacks (if any) are empty
	 */
	public boolean isEmpty() {
		for (DecreasingStack stack : stacks) {
			if (!stack.isEmpty())
				return false;
		}
		return true;
	}

	/**
	 * Pushes the provided element onto the first stack that accepts it.
	 * If there are no such stacks, add a new DecreasingStack to end of stack list,
	 * that is initialized with the element.
	 *
	 * @param element the element to push
	 */
	public void push(final int element) {
		for (DecreasingStack stack : stacks) {
			if (stack.push(element))
				return;
		}
		stacks.add(new DecreasingStack(element));
	}

	/**
	 * @return newline-separated string of stacks
	 */
	@Override
	public String toString() {
		String result = "";
		for (DecreasingStack stack : stacks) {
			result += "[" + stack.toString() + "]\n";
		}
		return result;
	}

	/**
	 * Remove and return the smallest element across all stacks.
	 *
	 * @return (and remove) the element from the stacks that is smalles
	 * @throws an appropriate subclass of RuntimeException if no element can be
	 *            popped
	 */
	public int pop() {
		int smallestElindex = 0;
		int smallestEl = Integer.MAX_VALUE;
		DecreasingStack smallestElStack = null;
		for (DecreasingStack stack : stacks) {
			for (int el : stack.stack) {
				if (el < smallestEl || smallestEl == Integer.MAX_VALUE) {
					smallestEl = el;
					smallestElindex = stack.stack.indexOf(el);
					smallestElStack = stack;
				}
			}
		}
		if (smallestEl == Integer.MAX_VALUE)
			throw new IndexOutOfBoundsException("no element can be popped");
		smallestElStack.stack.remove(smallestElindex);
		return smallestEl;
	}

	/**
	 * @return a List with the elements in increasing order.
	 *         If there are no elements, return an empty list.
	 *         The elements are also removed from this DecreasingStacks.
	 */
	public List<Integer> popAll() {
		List<Integer> result = new ArrayList<>();
		for (DecreasingStack stack : stacks) {
			while (true) {
				try {
					result.add(stack.pop());
				} catch (IndexOutOfBoundsException e) {
					break;
				}
			}
		}
		Collections.sort(result);
		return result;
	}

	// for your own use

	public static void main(final String[] args) {
		final DecreasingStacks stacks = new DecreasingStacks();
		List.of(5, 3, 8, 2, 1, 4, 4, 7, 6).forEach(stacks::push);
		System.out.println(stacks.toString());
		// Should print
		// [5, 3, 2, 1]
		// [8, 4]
		// [4]
		// [7, 6]

		System.out.println(stacks.pop());

		System.out.println(stacks.popAll());
		// Should print
		// [1, 2, 3, 4, 4, 5, 6, 7, 8]

		final DecreasingStacks stackboi = new DecreasingStacks();
		int[] ints = { 4, 5, 8, 7, 3, 5, 1, 3, 7, 8, 7, 5, 4, 3 };
		for (int i = 0; i < ints.length; i++) {
			stackboi.push(ints[i]);
		}
		System.out.println(stackboi.toString());
	}
}
