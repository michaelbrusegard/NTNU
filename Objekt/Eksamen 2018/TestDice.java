import org.junit.Assert;
import org.junit.Test;

public class TestDice {
    @Test
    public void testValueOf() {
        Dice dice1 = Dice.valueOf("[5,3,4]");
        assertDieValues(dice1, 5, 3, 4);
        Assert.assertEquals(-1, dice1.getScore());

        Dice dice2 = Dice.valueOf("[6,6,6]=600");
        assertDieValues(dice1, 6, 6, 6);
        Assert.assertEquals(600, dice1.getScore());

        try {
            Dice.valueOf("[5,3,4");
            Assert.fail();
        } catch (Exception e) {
            Assert.assertTrue(e instanceof IllegalArgumentException);
        }
    }
}
