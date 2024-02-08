// TreatmentUnit.fxml:<?xml version="1.0" encoding="UTF-8"?>

<?import javafx.scene.layout.VBox?><?import javafx.scene.control.Label?><?import javafx.scene.layout.HBox?><?
import javafx.scene.text.Font?>

<HBox xmlns:fx="http://javafx.com/fxml/1"fx:controller="ord2019.part5.TreatmentUnitController"><Label fx:id="patientMessage"text="&lt;Her kommer meldinger til pasienter&gt;"></Label></HBox>

// TreatmentUnitController.java:
public class TreatmentUnitController implements TreatmentObserver {

    TreatmentUnit treatmentUnit;

    public TreatmentUnitController() {
        treatmentUnit = new TreatmentUnit();

        // ... 5 b) other initialization ...
        treatmentUnit.addObserver(this);
    }

    // ... 5 b) declarations and methods here...

    @FXML
    label patientMessage;

    @Override
    public void treatmentStarted(Doctor doctor, Patient patient, TreatmentUnit treatmentUnit) {
        patientMessage.setText("pasient " + patient.toString() + " skal gå til doktor " + doctor.toString());
    }
}