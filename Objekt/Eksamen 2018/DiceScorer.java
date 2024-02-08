/**
 * (part 7)
 * Interface for scoring rules, i.e.
 * logic for computing a score for a subset of dice in a Dice
 */
public interface DiceScorer {
    /**
     * Computes a score for (a subset of) the dice in the Dice argument.
     * The return value includes those dice that gives the score, and
     * of course the score itself.
     *
     * @param dice
     * @return The dice for which the rule computes a score, and the score itself,
     *         or
     *         null, if this rule isn't applicable
     */
    Dice getScore(Dice dice);
}