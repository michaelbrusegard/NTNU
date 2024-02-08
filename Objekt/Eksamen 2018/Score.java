import java.util.ArrayList;
import java.util.Collection;

public class Score {

    private Collection<DiceScorer> diceScorers;

    /**
     * Computes a set of Dice with scores for the provided Dice.
     * 
     * @param dice
     * @return the set of Dice with die values and corresponding scores.
     */
    public Collection<Dice> computeDiceScores(Dice dice) {
        Collection<Dice> result = new ArrayList<>();
        while (dice.getDieCount() > 0) {
            Dice biggestScoreDice = new Dice(0);
            for (DiceScorer diceScorer : diceScorers) {
                Dice scoreDice = diceScorer.getScore(dice);
                if (scoreDice != null && scoreDice.getScore() > biggestScoreDice.getScore()) {
                    biggestScoreDice = scoreDice;
                }
            }
            if (biggestScoreDice.getScore() == -1) {
                break;
            }
            result.add(biggestScoreDice);
            dice = dice.remove(biggestScoreDice);
        }
        return result;
    }

    public int computeTotalPoints(Collection<Dice> diceObjectsWithScore) {
        return diceObjectsWithScore.stream().mapToInt(Dice::getScore).sum();
    }
}
