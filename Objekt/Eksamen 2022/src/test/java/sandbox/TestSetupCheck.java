package sandbox;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

public class TestSetupCheck {

	@Test
	public void testSample() {
		assertEquals("Gratulerer, Java-oppsettet ditt fungerer!", JavaSetupCheck.helloWorld());
	}
}
