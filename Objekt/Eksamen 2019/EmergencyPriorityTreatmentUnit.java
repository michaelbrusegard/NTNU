public class EmergencyPriorityTreatmentUnit extends PriorityTreatmentUnit {

    @Override
    public boolean startTreatment(Patient patient) {
        if (super.startTreatment(patient))
            return true;
        Patient suspendedPatient = null;
        for (Doctor doctor : getAllDoctors()) {
            if (doctor.canTreat(patient) > 0.0) {
                suspendedPatient = doctor.getPatient();
                if (suspendedPatient != null && getPriority(suspendedPatient) < getPriority(patient)) {
                    doctor.setPatient(patient);
                    return true;
                }
            }
        }
        if (suspendedPatient != null) {
            return startTreatment(suspendedPatient);
        }
        return false;
    }
}

/*
 * Here we assume that there is a method to get all doctors no matter if they
 * are occupied or not.
 */