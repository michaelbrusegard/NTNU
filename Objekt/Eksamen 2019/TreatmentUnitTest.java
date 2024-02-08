import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Used to test TreatmentUnit
 */
public class TreatmentUnitTest {
 
 
       private TreatmentUnit treatmentUnit;
 
 
       @Before
       public void setUp() {
             treatmentUnit = new TreatmentUnit();
   }
 
 
 
 
       @Test
       public void testAddDoctorsPatient() {
          final Doctor doctor1 = new Doctor(new ArrayList<>(Arrays.asList("flu"))); // new doctor can treat "flu"
          final Doctor doctor2 = new Doctor(new ArrayList<>(Arrays.asList("noseblead", "pneumonia"))); // new doctor can treat "noseblead" and "pneumonia"
       treatmentUnit.addDoctor(doctor1);
       treatmentUnit.addDoctor(doctor2);
          // Test that both doctors are available.
          Assertions.assertTrue(doctor1.isAvailable() && doctor2.isAvailable());
              
           final Patient patient = new Patient();
        patient.addConditions(new ArrayList<>(Arrays.asList("flu", "noseblead"))); // patient has conditions "flu" and "noseblead"
           // 2e) start sequence diagram 
        treatmentUnit.addPatient(patient);
           // Test that only one of the doctors are available:
        Assertions.assertEquals(1, treatmentUnit.getAvailableDoctors().size());
        Doctor patientDoctor = treatmentUnit.getDoctor(patient);
        patientDoctor.treat();
        treatmentUnit.treatmentFinished(patientDoctor);
     // 2e) end sequence diagram
           // Test that the previous doctor is available and that a
     // new doctor has been assigned to the patient.
         Assertions.assertTrue(patientDoctor.isAvailable());
         Assertions.assertNotEquals(patientDoctor, treatmentUnit.getDoctor(patient));
              
         patientDoctor = treatmentUnit.getDoctor(patient);
         patientDoctor.treat();
          treatmentUnit.treatmentFinished(patientDoctor);
             // Test that both doctors are available:
             Assertions.assertTrue(doctor1.isAvailable() && doctor2.isAvailable());
   }
}