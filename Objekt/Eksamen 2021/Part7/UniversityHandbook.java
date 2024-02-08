package Part7;

import java.io.InputStream;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;

public class UniversityHandbook {

    private Map<Course, List<String>> courses = new HashMap<>();
    private Map<String, Course> stringToCourse = new HashMap<>();

    /**
     * Reads all the courses from a given input stream. The courses are on this
     * form: courseName, averageGrade, prerequisite 1, prerequisite 2,
     * prerequisite 3....
     *
     * See courses.txt in src/main/resources/del7_og_8 for an example file.
     *
     * Calling this method should remove any existing courses from the handbook.
     *
     * A given course can have anything from 0 to unlimited number of prerequisites.
     * The courses do not necessary come in order. Meaning that a course may appear
     * in the prerequisite list as a never before seen course. The method should
     * read
     * in all courses, and set the courseName, averageGrade and prerequisites of all
     * courses and add the courses to the courses field of this class.
     *
     * A skeleton code to read from file is provided to you but feel free to write
     * your own code for this.
     *
     * You can assume that all lines from the file will be on the correct format.
     *
     * @param stream InputStream containing the course data
     */
    public void readFromInputStream(InputStream stream) {
        try (Scanner scanner = new Scanner(stream)) {
            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                List<String> details = Arrays.asList(line.split(","));

                // TODO - Continue implementation here
                String courseName = details.get(0);
                Double averageGrade = Double.parseDouble(details.get(1));
                Course course = new Course(courseName, averageGrade);
                stringToCourse.put(courseName, course);
                List<String> prerequisites = details.subList(2, details.size());
                courses.put(course, prerequisites);
            }
        }
        for (Map.Entry<Course, List<String>> course : courses.entrySet()) {
            for (String prerequisite : course.getValue()) {
                Course prerequisiteCourse = stringToCourse.get(prerequisite);
                course.getKey().addPrequisite(prerequisiteCourse);
            }
        }
    }

    /**
     * Gets the course with the courseName
     *
     * @param courseName The name of the course
     *
     * @return The course with the given name
     */
    public Course getCourse(String courseName) {
        return stringToCourse.get(courseName);
    }
}