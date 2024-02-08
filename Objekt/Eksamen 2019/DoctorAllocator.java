public interface DoctorAllocator {

    /**
     * Finds the patient in the TreatmentUnit that the provided doctor
     * should start treating.
     * Note: The method should be free of side effects, i.e. should not modify any
     * object.
     * 
     * @param doctor
     * @param treatmentUnit
     * @return the patient that the doctor should treat, or null.
     */
    public Patient allocatePatient(Doctor doctor, TreatmentUnit treatmentUnit);

    /**
     * Finds the doctor in the TreatmentUnit that the provided patient
     * should be treated by.
     * Note: The method should be free of side effects, i.e. should not modify any
     * object.
     * 
     * @param patient
     * @param treatmentUnit
     * @return The doctor that should treat the provided patient, or
     *         null if none was found.
     */
    public Doctor allocateDoctor(Patient patient, TreatmentUnit treatmentUnit);
}