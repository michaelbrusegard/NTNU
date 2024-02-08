package part1;

import java.util.ArrayList;
import java.util.List;

public class Player {

	private List<PlayerGameStat> seasonStats = new ArrayList<PlayerGameStat>();
	private final String name;
	private final int height;

	public Player(final String name, final int height, final List<PlayerGameStat> seasonStats) {
		this.name = name;
		this.height = height;
		this.seasonStats = new ArrayList<>(seasonStats);
	}

	public List<PlayerGameStat> getSeasonStats() {
		return new ArrayList<>(seasonStats);
	}

	public String getName() {
		return name;
	}

	public int getHeight() {
		return height;
	}
}
