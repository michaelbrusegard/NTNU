public class DiceController {
    @FXML
    private TextField dieCountInput;
    @FXML
    private Label diceOutput;

    @FXML
    public void handleThrowDice() {
        Dice dice = Dice(Integer.parseInt(dieCountInput.getText()));
        computeFarkleScore(dice);
        diceOutput.setText(dice.toString());
    }
}
