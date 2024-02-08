public abstract class AbstractDice implements DiceInterface {
    private int score = -1;

    public String toString() {
        String result = "[";
        for (int dieValue : this) {
            result += Integer.toString(dieValue) + ",";
        }

        result = result.substring(0, result.length() - 1) + "]";
        if (this.score != -1) {
            result += "=" + Integer.toString(this.score);
        }

        return result;
    }

    public int getValueCount(int value) {
        int count = 0;
        for (int dieValue : this) {
            if (dieValue == value) {
                count++;
            }
        }
        return count;
    }

    public int getScore() {
        return this.score;
    }

    public void setScore(int score) {
        if (this.score != -1) {
            throw new IllegalArgumentException("Score already set");
        }
        this.score = score;
    }
}
