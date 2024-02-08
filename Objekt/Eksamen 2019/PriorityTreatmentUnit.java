public class PriorityTreatmentUnit extends TreatmentUnit {

    public double getPriority(Patient patient) {
        return 0.0;
    }

    @Override
    protected boolean startTreatment(final Doctor doctor) {
        Patient importantPatient = null;

        for (Patient patient : getWaitingPatients()) {
            if (doctor.canTreat(patient) > 0.0) {
                if (importantPatient == null || getPriority(patient) > getPriority(importantPatient)) {
                    importantPatient = patient;
                }
            }
        }

        if (importantPatient == null) {
            return false;
        }

        doctor.setPatient(importantPatient);
        return true;
    }
}

/*
 * We dont have to make any changes to the TreatmentUnit class it will work as
 * it has been. We extend its functionality for the PriorityTreatmentUnit to
 * check for
 * the patient that has the highest priority and after finding that we see if
 * the doctor can treat the patient. We implement the startTreatment method for
 * the doctor
 * because when the patinet is already given it doesnt make ssense to try and
 * find the one with hgiehst priority.
 */

/*
 * The heritage structure will be TreatmentUnit < PriorityTreatmentUnit <
 * EmergencyPriorityTreatmentUnit
 */