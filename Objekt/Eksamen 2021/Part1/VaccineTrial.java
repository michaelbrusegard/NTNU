package Part1;

import java.util.HashMap;

public class VaccineTrial {

    // Add any needed fields here
    HashMap<String, VaccineTrialVolunteer> volunteers = new HashMap<>();

    /**
     * Adds a new VaccineTrialVolunteer to the trial
     *
     * @param id      The id of the volunteer
     *
     * @param placebo Whether the volunteer was given a placebo, or the actual
     *                vaccine
     */

    public void addVolunteer(String id, boolean placebo) {
        VaccineTrialVolunteer volunteer = new VaccineTrialVolunteer(id, placebo);
        volunteers.put(id, volunteer);
    }

    /**
     * Returns whether the vaccine's effectiveness rate is higher than the provided
     * limit. The effectiveness of the vaccine is calculated as follows:
     *
     * 1- (number of people that received the vaccine and got sick/
     * number of people that got sick)
     *
     * If there is no sick people, the vaccine is not effective
     *
     * @param limit A limit to compare against
     *
     * @throws IllegalArgumentException If limit is not between (including) 0 and 1.
     *
     * @return Whether the vaccine effectiveness rate is higher than the limit
     */
    public boolean isMoreEffectiveThanLimit(double limit) {
        if (limit < 0 || limit > 1) {
            throw new IllegalArgumentException("provided limit out of range");
        }
        int vaccineSickPeople = 0, sickPeople = 0;

        for (VaccineTrialVolunteer volunteer : volunteers.values()) {
            if (volunteer.gotSick()) {
                sickPeople++;
                if (!volunteer.isPlacebo())
                    vaccineSickPeople++;
            }
        }
        double vaccineEfficiency = 1 - (vaccineSickPeople / sickPeople);
        return vaccineEfficiency > limit;
    }

    /**
     * Updates the sick state of a VaccineTrialVolunteer
     *
     * @param id The id of the volunteer to set sick.
     * @throws IllegalArgumentException if there is no volunteer with the given id
     */
    public void setSick(String id) {
        VaccineTrialVolunteer volunteer = volunteers.get(id);
        volunteer.setGotSick(true);
    }

    /**
     * Get's the volunteer with the given ID
     *
     * @param id The id of the volunteer to set sick.
     *
     * @return The vaccine trial volunteer with the given ID. If the ID is not valid
     *         for any volunteer, return null
     */
    public VaccineTrialVolunteer getVolunteer(String id) {
        return volunteers.get(id);
    }

}