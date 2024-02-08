import java.util.Iterator;

public class DiceAdder extends AbstractDice {
    private final Dice dice1, dice2;

    DiceAdder(Dice dice1, Dice dice2) {
        this.dice1 = dice1;
        this.dice2 = dice2;
    }

    @Override
    public int getDieCount() {
        return dice1.getDieCount() + dice2.getDieCount();
    }

    @Override
    public Iterator<Integer> iterator() {
        return iterator();
    }

    @Override
    public int getValueCount(int value) {
        return dice1.getValueCount(value) + dice2.getValueCount(value);
    }

    // Here we assume that the input index is first referencing dice1 and then dice2
    @Override
    public int getDieValue(int dieNum) {
        int dieCount = dice1.getDieCount();
        if (dieCount > dieNum) {
            return dice1.getDieValue(dieNum);
        }
        return dice2.getDieValue(dieNum - dieCount);
    }

    @Override
    public boolean contains(Dice dice) {
        if (dice1.contains(dice) || dice2.contains(dice)) {
            return true;
        }
        return false;
    }

    @Override
    public DiceAdder add(Dice dice) {
        return new DiceAdder(dice, dice);
    }

    @Override
    public DiceAdder remove(Dice dice) {
        Dice newDice1 = dice1.remove(dice);
        Dice newDice2 = dice2.remove(dice);
        return new DiceAdder(newDice1, newDice2);
    }
}