public interface DiceInterface extends Iterable<Integer> {
    int getScore();

    void setScore(int score);

    int getDieCount();

    int getDieValue(int dieNum);

    int getValueCount(int value);

    boolean contains(Dice dice);

    DiceAdder add(Dice dice);

    DiceAdder remove(Dice dice);
}
