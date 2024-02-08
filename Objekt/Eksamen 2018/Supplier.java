public interface Supplier<T> {
    /**
     * Gets a result.
     * 
     * @return a result of the type T
     */
    T get();
}