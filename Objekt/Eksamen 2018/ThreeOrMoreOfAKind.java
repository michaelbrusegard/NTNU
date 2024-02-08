import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ThreeOrMoreOfAKind implements DiceScorer {
    @Override
    public Dice getScore(Dice dice) {
        Map<Integer, Integer> countMap = new HashMap<>();
        for (int dieValue : dice) {
            countMap.put(dieValue, countMap.getOrDefault(dieValue, 0) + 1);
        }

        int biggestScore = 0;
        int biggestDie = 0;
        for (Map.Entry<Integer, Integer> entry : countMap.entrySet()) {
            int score = 0;
            if (entry.getValue() >= 3) {
                score = calculateScore(entry.getKey(), entry.getValue());
                if (score > biggestScore) {
                    biggestScore = score;
                    biggestDie = entry.getKey();
                } else if (score == biggestScore && entry.getKey() > biggestDie) {
                    biggestDie = entry.getKey();
                }
            } else {
                return null;
            }
        }

        List<Integer> dieValues = new ArrayList<>(biggestDie);
        for (int i = 0; i < biggestDie; i++) {
            dieValues.add(biggestDie);
        }

        return new Dice(dieValues, biggestScore);
    }

    private int calculateScore(int dieValue, int numberOfDie) {
        int score = dieValue * 100;
        if (numberOfDie > 3) {
            for (int i = 3; i < numberOfDie; i++) {
                score *= 2;
            }
        }
        return score;
    }
}
