package Part4;

import java.util.Comparator;
import java.util.List;

public class AthleteComparators {

    /**
     * @return a comparator that compares athletes based on their name. Using this
     *         comparator, Ane should come before Berit
     */
    public static Comparator<Athlete> getSimpleComparator() {
        return new Comparator<Athlete>() {

            @Override
            public int compare(Athlete o1, Athlete o2) {
                return o1.getName().compareTo(o2.getName());
            }
        };
    }

    /**
     * @return A comparator that compares athletes based on the number of medals of
     *         different valour. The comparator will be used for sorting athletes
     *         based on putting the athlete with the highest number of medals of the
     *         best valour
     *         first.
     *
     *         If one athlete has more "Gold" medals than the other athlete it
     *         should come before that one. If they have equal number of "Gold"
     *         medals they should be compared on the number of "Silver" medals, and
     *         if that is equal on the number of "Bronze" medals. If they have the
     *         same number of medals of all valour, they should be compared based
     *         on the name similar to getSimpleComparator
     * 
     *         The spelling and order of the medals can be seen in the list
     *         validMetals in the Medal class.
     */
    public static Comparator<Athlete> getAdvancedComparator() {
        return new Comparator<Athlete>() {

            @Override
            public int compare(Athlete o1, Athlete o2) {
                int[] o1medals = getMedalsAmount(o1.getMedals());
                int[] o2medals = getMedalsAmount(o2.getMedals());
                if (o1medals[0] != o2medals[0])
                    return Integer.compare(o1medals[0], o2medals[0]);
                else if (o1medals[1] != o2medals[1])
                    return Integer.compare(o1medals[1], o2medals[1]);
                else if (o1medals[2] != o2medals[2])
                    return Integer.compare(o1medals[2], o2medals[2]);
                else
                    return getSimpleComparator().compare(o1, o2);
            }

        };
    }

    private static int[] getMedalsAmount(List<Medal> medals) {
        int gold = 0, silver = 0, bronze = 0;
        for (Medal medal : medals) {
            if (medal.getMetal().equals("Gold"))
                gold++;
            else if (medal.getMetal().equals("silver"))
                silver++;
            else
                bronze++;
        }
        return new int[] { gold, silver, bronze };
    }
}