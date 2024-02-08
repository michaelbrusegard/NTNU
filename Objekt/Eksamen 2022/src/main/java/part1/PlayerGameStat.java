package part1;

public class PlayerGameStat {

	private final int fieldGoalAttempts;
	private final int freeThrowAttempts;
	private final int pointsScored;

	public PlayerGameStat(final int pointsScored, final int fieldGoalAttempts, final int freeThrowAttempts) {
		this.pointsScored = pointsScored;
		this.fieldGoalAttempts = fieldGoalAttempts;
		this.freeThrowAttempts = freeThrowAttempts;
	}

	public int getPointsScored() {
		return pointsScored;
	}

	public int getFieldGoalAttempts() {
		return fieldGoalAttempts;
	}

	public int getFreeThrowAttempts() {
		return freeThrowAttempts;
	}
}
