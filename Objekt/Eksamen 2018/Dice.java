import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.function.Supplier;

/**
 * Represents a set of die values. A die has six possible values 1-6,
 * but the number of dice may vary from Dice instance to Dice instance.
 * In addition, a Dice-instance can have a score.
 */
public class Dice implements Iterable<Integer> {

    /**
     * @param dieCount
     * @return a collection of random integer values in the range 1-6
     */
    public static Collection<Integer> randomDieValues(int dieCount) {
        Collection<Integer> dieValues = new ArrayList<>(dieCount);
        for (int dice = 0; dice < dieCount; dice++) {
            dieValues.add((int) (Math.random() * 6) + 1);
        }

        return dieValues;
    }

    private List<Integer> dieValues = new ArrayList<>();
    private int score = -1;

    /**
     * (part 1)
     * Initializes this Dice with the values in dieValues, and a score.
     * 
     * @param dieValues
     * @param score     the score to set, may be -1 for yet unknown
     * @throws a suitable exception if the die values are outside the valid range
     */
    public Dice(Collection<Integer> dieValues, int score) {
        for (int dieValue : dieValues) {
            if (!(dieValue >= 1 && dieValue <= 6)) {
                throw new IllegalArgumentException("Die value outside valid range");
            }

            this.dieValues.add(dieValue);
        }

        this.score = score;
    }

    /**
     * (part 1)
     * Initializes this Dice with dieCount random values (using Math.random())
     * 
     * @param dieCount
     */
    public Dice(int dieCount) {
        this(randomDieValues(dieCount), -1);
    }

    /**
     * (part 1)
     * Initializes this Dice with the values in dice, and a score
     * 
     * @param dieValues // Denne skulle vært bare "dice", ikke "dieValues"
     * @param score     the score to set, may be -1 for yet unknown
     */
    public Dice(Dice dice, int score) {
        this(dice.dieValues, score);
    }

    /**
     * (part 2)
     * Format: [die1, die2, ...] = score (score is omitted when < 0)
     */
    @Override
    public String toString() {
        String result = "[";
        for (int dieValue : this.dieValues) {
            result += Integer.toString(dieValue) + ",";
        }

        result = result.substring(0, result.length() - 1) + "]";
        if (this.score != -1) {
            result += "=" + Integer.toString(this.score);
        }

        return result;
    }

    /**
     * (part 2)
     * Parses a string using the toString format (see above) and
     * returns a corresponding Dice.
     * 
     * @param s
     * @return a new Dice instance initialized with die values and score from the
     *         String argument
     */
    public static Dice valueOf(String s) {
        int score = -1;
        String[] parts = s.split("=");
        if (parts.length > 0) {
            score = Integer.parseInt(parts[1]);
        }

        String[] sValues;
        if (parts[0].startsWith("[") && parts[0].endsWith("]")) {
            sValues = parts[0].substring(1, parts[0].length() - 1).split(",");
        } else {
            throw new IllegalArgumentException("Illegal format");
        }

        Collection<Integer> dieValues = new ArrayList<>(sValues.length);
        for (int i = 0; i < sValues.length; i++) {
            dieValues.add(Integer.parseInt(sValues[i]));
        }

        return new Dice(dieValues, score);
    }

    /**
     * (part 3)
     * 
     * @return the number of die values
     */
    public int getDieCount() {
        return this.dieValues.size();
    }

    /**
     * (part 3)
     * 
     * @param dieNum
     * @return the value of die number dieNum
     */
    public int getDieValue(int dieNum) {
        return this.dieValues.get(dieNum);
    }

    /**
     * (part 3)
     * 
     * @param value
     * @return the number of dice with the provided value
     */
    public int getValueCount(int value) {
        int count = 0;
        for (int dieValue : this.dieValues) {
            if (dieValue == value) {
                count++;
            }
        }
        return count;
    }

    /**
     * (part 4)
     * 
     * @return the current score
     */
    public int getScore() {
        return this.score;
    }

    /**
     * (part 4)
     * Sets the score, but only if it isn't already set to a non-negative value
     * 
     * @param score
     * @throws a suitable exception if score already is set to a non-negative value
     */
    public void setScore(int score) {
        if (this.score != -1) {
            throw new IllegalArgumentException("Score already set");
        }
        this.score = score;
    }

    @Override
    public Iterator<Integer> iterator() {
        return this.dieValues.iterator();
    }

    public static void main(String[] args) {
        Dice dice = new Dice(5);
        for (int dieValue : dice) {
            System.out.println(dieValue);
        }

        // Create a test case for the remove function
        Dice dice1 = new Dice(List.of(1, 2, 3, 4, 5), -1);
        Dice removeDice = new Dice(List.of(2, 4), -1);

        System.out.println("Original dice: " + dice1.toString());

        // Call the remove function
        Dice result = dice1.remove(removeDice);

        System.out.println("Removed dice: " + removeDice.toString());
        System.out.println("Resulting dice: " + result.toString());
    }

    /**
     * (part 6) // Denne ble det ikke spurt om, og det var ikke meningen at den
     * skulle implementeres, men den kunne brukes
     * 
     * @param dice
     * @return true if all die values in the argument appear in this Dice
     */
    public boolean contains(Dice dice) {
        for (int dieValue : dice) {
            if (!this.dieValues.contains(dieValue)) {
                return false;
            }
        }
        return true;
    }

    /**
     * (part 6)
     * 
     * @param dices a Collection of Dice // Denne linja var feil, det skulle være
     *              bare "dice a Dice"
     * @return a new Dice instance with the all the die values this Dice and
     *         all Dice in the argument, without any specific order
     */
    public Dice add(Dice dice) {
        Collection<Integer> dieValues = new ArrayList<>(this.dieValues);
        for (int dieValue : dice) {
            dieValues.add(dieValue);
        }
        return new Dice(dieValues, -1);
    }

    /**
     * (part 6)
     * 
     * @param dice
     * @return a new Dice instance with the die values from this Dice, but
     *         without those from the argument, without any specific order
     */
    public Dice remove(Dice dice) {
        Collection<Integer> dieValues = new ArrayList<>(this.dieValues);
        for (int dieValue : dice) {
            if (dieValues.contains(dieValue)) {
                dieValues.remove(dieValue);
            }
        }
        return new Dice(dieValues, -1);
    }

    /**
     * Initializes this Dice with n die values provided by the supplier argument.
     * 
     * @param dieCount the number of dice to "throw"
     * @param supplier provides the die values
     */
    public Dice(int dieCount, Supplier<Integer> supplier) {
        this.dieValues = new ArrayList<>(dieCount);
        for (int i = 0; i < dieCount; i++) {
            this.dieValues.add(supplier.get());
        }
        this.score = -1;
    }
}