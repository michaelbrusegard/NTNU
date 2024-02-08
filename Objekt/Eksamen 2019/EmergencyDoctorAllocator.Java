class DefaultDoctorAllocator extends PriorityDoctorAllocator {

       protected double getPriority(final Patient patient) {
         
        return 0.0;
    }
    
     public Dcotor allocateDoctor(Doctor doctor, TreatmentUnit treatmentUnit) {
       Doctor basicDoctor = super.allocateDoctor(doctor, treatmentUnit)
       if (basicDoctor != null) return basicDoctor;
        Patient suspendedPatient = null;
        for (Doctor doctor : getAllDoctors()) {
            if (doctor.canTreat(patient) > 0.0) {
                suspendedPatient = doctor.getPatient();
                if (suspendedPatient != null && getPriority(suspendedPatient) < getPriority(patient)) {
                    return doctor;
                }
            }
        }
        if (suspendedPatient != null) {
            return treatmentUnit.getDoctor(suspendedPatient);
        }
        return null;
    }
}