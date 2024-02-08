package part2;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

public class DecreasingStackTest {
    @Test
    public void testStacks() {
        final DecreasingStacks stackboi = new DecreasingStacks();

        stackboi.push(5);
        assertEquals(stackboi.pop(), 5);

        int[] ints = { 4, 5, 8, 7, 3, 5, 1, 3, 7, 8, 7, 5, 4, 3 };
        for (int i = 0; i < ints.length; i++) {
            stackboi.push(ints[i]);
        }

        assertEquals(stackboi.pop(), 1);

        assertEquals(stackboi.toString(), "[4,3]\n[5,5,3,3]\n[8,7,7,7,5,4]\n[8]\n");
    }

}
