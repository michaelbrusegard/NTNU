package Part2;

public class Person {

    // No other fields should be added to this class
    private Address address;

    // You do not need to consider the edge case of passing null into the
    // constructor here
    public Person(Address address) {
        this.address = address;
    }

    /**
     *
     * @return the street name of this person
     */
    public String getStreetName() {
        return this.address.getStreetName();
    }

    /**
     * Updates the street name of this person
     *
     * @param streetName The street name to update
     */
    public void setStreetName(String streetName) {
        int streetNumber = this.address.getStreetNumber();
        this.address = new Address(streetName, streetNumber);
    }

    public int getStreetNumber() {
        return this.address.getStreetNumber();

    }

    /**
     * Updates the street number of this person
     *
     * @param streetNumber A positive integer.
     *
     * @throws IllegalArgumentException If number is not larger than 0.
     */

    public void setStreetNumber(int streetNumber) {
        if (streetNumber <= 0)
            throw new IllegalArgumentException("number is not larger than 0");
        String streetName = this.address.getStreetName();
        this.address = new Address(streetName, streetNumber);
    }
}