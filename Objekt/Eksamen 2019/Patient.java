import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;

/** * A patient has a set of (health) conditions (of type String) that needs to be treated.
 * Supports iterating over the patient's conditions.
 */
public class Patient implements Iterable<String> {
 
 
       // Add fields, constructors, and methods here: // 2a
       private Collection<String> conditions = new ArrayList<>();

       public void addConditions(Collection<String> conditions) {
        this.conditions.addAll(conditions);
       }

       public void removeConditions(Collection<String> conditions) {
        this.conditions.removeAll(conditions);
       }

       public Collection<String> getConditions() {
        Collection<String> result = new ArrayList<>(this.conditions);
        return result;
       }
        // Support iteration // 2a
            @Override
    public Iterator<String> iterator() {
        return conditions.iterator();
    }
     /**
    * Indicates if this patient has conditions that needs to be treated.
    * @return true if this patient has conditions that needs to be treated,
    * false otherwise.
    */
       public boolean requiresTreatment() { // 2a
        return !conditions.isEmpty();
   }
}