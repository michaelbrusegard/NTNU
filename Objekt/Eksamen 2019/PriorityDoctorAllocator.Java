class DefaultDoctorAllocator extends DefaultDoctorAllocator {

       protected double getPriority(final Patient patient) {
         
        return 0.0;
    }

     public Patient allocatePatient(Doctor doctor, TreatmentUnit treatmentUnit) {
       Patient importantPatient = null;

        for (Patient patient : treatmentUnit.getWaitingPatients()) {
            if (doctor.canTreat(patient) > 0.0) {
                if (importantPatient == null || getPriority(patient) > getPriority(importantPatient)) {
                    importantPatient = patient;
                }
            }
        }

        if (importantPatient == null) {
            return null;
        }
        return importantPatient;
     }
}