import java.util.ArrayList;
import java.util.Collection;

/**
 * Represents a round of Farkle, where a player throws and keeps dice,
 * until s/he either "bank", i.e. save your points, or
 * farkle, i.e. get no points in a throw and hence looses all gathered points.
 * During and after a finished round, kept sets of dice and their scores are
 * available.
 * During a round, the remaining dice are also available.
 */
public class FarkleRound {
    final private int dieCount;
    final private Collection<Dice> kept = new ArrayList<>();
    private Dice currentDice;

    /**
     * Initializes a new round, where dieCount number of dice is immediately rolled.
     * Note that the round may be immedielately finished, if the initial roll give
     * no points.
     * 
     * @param dieCount the number of dice rolled
     * @param scoring  the object responsible for computing the score
     */
    public FarkleRound(int dieCount) {
        this.dieCount = dieCount;
        roll(dieCount);
    }

    private void roll(int dieCount) {
        this.currentDice = new Dice(Dice.randomDieValues(dieCount), -1);
        if (computeDiceScores(currentDice).isEmpty()) {
            this.kept.clear();
            this.currentDice = null;
        }
    }

    private Collection<Dice> computeDiceScores(Dice dice) {
       ... implemented earlier in this exam ...
    }

    /**
     * @return true of the round is finised, false otherwise
     */
    public boolean isFinished() {
        return this.currentDice == null;
    }

    /**
     * Called when the player decides to stop and secure points.
     * Finishes the round, by keeping all scoring Dice, as computed by the scoring
     * object.
     */
    public void bank() {
        if (isFinished()) {
            throw new IllegalStateException();
        }
        this.kept.addAll(computeDiceScores(currentDice));
        this.currentDice = null;
    }

    /**
     * Called when the player decides to keep specific dice and roll the rest.
     * All the dice kept must be scoring ones, but not all scoring dice need to be
     * kept.
     * 
     * @param dice the dice to keep, the rest of the current dice should be thrown.
     */
    public void keepAndRoll(final Dice dice) {
        if (isFinished()) {
            throw new IllegalStateException("No dice to be thrown");
        }
        if (!currentDice.contains(dice)) {
            throw new IllegalArgumentException("Dice that is held is not the same as the one to be thrown");
        }
        final Collection<Dice> scores = computeDiceScores(dice);
        if (scores.stream().mapToInt(Dice::getDieCount).sum() != dice.getDieCount()) {
            throw new IllegalArgumentException("You can only set aside dice that contribute to the score");
        }
        kept.addAll(scores);
        currentDice = currentDice.remove(dice);
        // roll remaining dice or all, if there are none left
        int count = currentDice.getDieCount();
        if (count == 0) {
            count = this.dieCount;
        }
        roll(count);
    }
}