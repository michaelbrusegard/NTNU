import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.function.Predicate;

/**
 * A class for managing a set of doctors and the patients they're treating.
 * When doctors or patients arrive, it is made sure that patients are treated as
 * soon as possible.
 */
public abstract class TreatmentUnit {

       // Internal variables go here: // 1b
       private Collection<Doctor> doctors = new ArrayList<>();
       private Collection<Patient> patients = new ArrayList<>();
       private DoctorAllocator doctorAllocator = new DefaultDoctorAllocator();

       /**
        * Adds a doctor and makes sure s/he starts treating a patient, if one is
        * waiting.
        * 
        * @param doctor
        */
       public void addDoctor(final Doctor doctor) { // 1b
              doctors.add(doctor);
              startTreatment(doctor);
       }

       /**
        * @return the currently available doctors
        */
       public Collection<Doctor> getAvailableDoctors() { // 1b
              Collection<Doctor> availableDoctors = new ArrayList<>();
              for (Doctor doctor : doctors) {
                     if (doctor.isAvailable())
                            availableDoctors.add(doctor);
              }
              return availableDoctors;
       }

       /**
        * Adds a patient to this treatment unit, and makes sure treatment starts if any
        * doctor is available.
        * Otherwise the patient is queued for treatment when a doctor becomes
        * available.
        * 
        * @param patient
        */
       public void addPatient(final Patient patient) { // 1b
              patients.add(patient);
              startTreatment(patient);
       }

       /**
        * @param pred the predicate that the doctor must satisfy
        * @return some doctor satisfying the predicate
        */
       public Doctor getDoctor(final Predicate<Doctor> pred) { // 1b
              for (Doctor doctor : doctors) {
                     if (pred.test(doctor))
                            return doctor;
              }
              return null;
       }

       /**
        * Find the doctor, if any, that treats the provided patient.
        * 
        * @param patient
        * @return the doctor treating the provided patient, or null, of the patient
        *         isn't currently being treated
        */
       public Doctor getDoctor(final Patient patient) { // 1b
              return getDoctor(doctor -> doctor.getPatient() == patient);
       }

       /**
        * Find all patients that are not currently being treated.
        * 
        * @return the patients not currently being treated.
        */
       public Collection<Patient> getWaitingPatients() { // 1b
              final Collection<Patient> result = new ArrayList<>();
              for (Patient patient : patients) {
                     if (getDoctor(patient) == null)
                            result.add(patient);
              }
              return result;
       }

       /**
        * Finds a waiting patient and sets him/her as the provided doctor's patient.
        * 
        * @param doctor the doctor for which a patient to treat should be found
        * @return true if a patient for the provided doctor was found, false
        *         otherwise.
        */
       private boolean startTreatment(final Doctor doctor) { // 1c
              if (getWaitingPatients().isEmpty())
                     return false;
              doctor.setPatient(getWaitingPatients().iterator().next());
              return true;
       }

       /**
        * Finds an available doctor for the provided patient, and sets that doctor to
        * treat the patient.
        * 
        * @param patient the patient for which a treating doctor should be found.
        * @return true if a doctor for the provided patient was found, false
        *         otherwise.
        */
       private boolean startTreatment(final Patient patient) { // 1c
              if (getAvailableDoctors().isEmpty())
                     return false;
              getAvailableDoctors().iterator().next().setPatient(patient);
              return true;
       }

       /**
        * Removes the link between doctor and patient, after treatment is finished.
        * Since the patient is fully treated, s/he is removed from this treatment
        * unit.
        * Also ensure the doctor starts treating another patient.
        * 
        * @param doctor the doctor that has finished treating his/her patient.
        */
       public void treatmentFinished(final Doctor doctor) { // 1c
              patients.remove(doctor.getPatient());
              doctor.setPatient(null);
              startTreatment(doctor);
       }

       // Internal declaration hidden

       /**
        * Finds a waiting patient and sets him/her as the provided doctor's patient.
        * Will only accept a patient that has some condition that the doctor actually
        * can treat.
        * 
        * @param doctor the doctor for which a patient to treat should be found
        * @return true if a patient for the provided doctor was found, false
        *         otherwise.
        */
       protected boolean startTreatment(final Doctor doctor) {
              // Possible changes
              for (Patient patient : getWaitingPatients()) {
                     if (doctor.canTreat(patient) > 0.0) {
                            doctor.setPatient(patient);
                            return true;
                     }
              }
              return false;
       }

       /**
        * Finds an available doctor for the provided patient, and sets that
        * doctor to treat the patient.
        * Will only accept a doctor that actually can treat some condition for the
        * provided patient.
        * 
        * @param patient the patient for which a treating doctor should be found
        * @return true if a doctor for the provided patient was found, false
        *         otherwise.
        */
       protected boolean startTreatment(final Patient patient) {
              // Possible changes
              for (Doctor doctor : getAvailableDoctors()) {
                     if (doctor.canTreat(patient) > 0.0) {
                            doctor.setPatient(patient);
                            return true;
                     }
              }
              return false;
       }

       /**
        * Removes the link between doctor and patient, after treatment is finished.
        * If the patient is fully treated, s/he is removed from this treatment unit,
        * otherwise another round of treatment is initiated.
        * Also ensure the doctor starts treating another patient.
        * 
        * @param doctor the doctor that has finished treating his/her patient
        */
       public void treatmentFinished(final Doctor doctor) {
              // Possible changes
              Patient patient = doctor.getPatient();
              doctor.setPatient(null);
              if (patient.requiresTreatment()) {
                     startTreatment(patient);
              } else {
                     patients.remove(patient);
              }
              startTreatment(doctor);
       }

       protected boolean startTreatment(final Doctor doctor) { // Part 4
              final Patient patient = doctorAllocator.allocatePatient(doctor, this);
              if (patient == null)
                     return false;
              doctor.setPatient(patient);
              triggerTreatment(doctor, patient);
              return true;
       }

       protected boolean startTreatment(final Patient patient) { // Part 4
              final Doctor doctor = doctorAllocator.allocateDoctor(patient, this);
              if (patient == null)
                     return false;
              doctor.setPatient(patient);
              triggerTreatment(doctor, patient);
              Patient oldPatient = doctor.getPatient();
              if (oldPatient != null)
                     startTreatment(oldPatient);
              return true;
       }

       private List<TreatmentObserver> observers = new ArrayList<>();

       public void addObserver(TreatmentObserver observer) {
              observers.add(observer);
       }

       public void removeObserver(TreatmentObserver observer) {
              observers.remove(observer);
       }

       public void triggerTreatment(Doctor doctor, Patient patient) {
              for (TreatmentObserver observer : observers) {
                     TreatmentObserver.treatmentStarted(doctor, patient, this);
              }
       }
}