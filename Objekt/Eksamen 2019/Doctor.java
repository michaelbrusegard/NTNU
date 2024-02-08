import java.util.ArrayList;
import java.util.Collection;

/**
 * A doctor has the capacity to treat one patient at a time.
 */
public class Doctor {
       // Internal variables go here:
       private Patient currentPatient;
       private Collection<String> competencies;
 
       /**     
 * @return the patient this doctor is treating, or null if s/he isn't currently treating any patient.
        */
       public Patient getPatient() { // 1a
              return this.currentPatient;
       }
 
 
       /**
        * @return true if this doctor is currently treating a patient, otherwise false.
        */
       public boolean isAvailable() { // 1a
              if (currentPatient == null) return true;
              return false;
       }
 
 
       /**
        * Sets the patient that this doctor is treating, use null to indicate s/he isn't currently treating any patient.
        * @param patient
        */
       public void setPatient(final Patient patient) { // 1a
              this.currentPatient = patient;
       }

              /**
    * Initialise this doctor with a set of competencies.
    * @param competencies
    */
       public Doctor(Collection<String> competencies) { // 2b
              this.competencies = new ArrayList<>(competencies);
   }
        
       /**
     * Indicates to what extent this doctor can treat the provided patient.
     * The value is the number of the patient's conditions this doctor
     * can treat divided by the number of conditions the patient has.
     * Conditions and competences are matched using simple String comparison.
     * @param patient
     * @return the ratio of the patient's conditions that this
     * doctor can treat.
     */
       public double canTreat(final Patient patient) { // 2b
              int count = 0;
              for (String condition : patient) {
                     if (competencies.contains(condition)) {
                            count++;
                     }
              }
              return count / patient.getConditions().size();
   }
 
 
       /**
    * "Treats" the patient by removing all the patient's conditions
    * that this doctor can treat.
    */
       public void treat() { // 2b
              currentPatient.removeConditions(competencies);
   }
}
  