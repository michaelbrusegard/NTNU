/* Part 2 */
console.log('PART 2');

for (let i = 1; i <= 20; i++) {
    console.log(i);
}
/* Made a for loop from 1 to 20 print the loop index */

/* Part 3 */
console.log('PART 3');

const numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

for (let i = 1; i <= numbers.length; i++) {
    if (i % 3 == 0 & i % 5 == 0) {
        console.log('eplekake');
    } else if (i % 3 == 0) {
        console.log('eple');
    } else if (i % 5 == 0) {
        console.log('kake');
    } else {
        console.log(numbers[i - 1]);
    }
}
/* Made a for loop that goes from q to the length of the array, it check if the index is divisible using modulo adn the prints the corresponding string */

/* Part 4 */
document.getElementById('title').innerHTML = 'Hello, JavaScript';
/* Adds the text to the corresponding elements Id */

/* Part 5 */
function changeDisplay() {
    const box = document.getElementById('magic');
    box.style.display = 'none';
}

function changeVisibility() {
    const box = document.getElementById('magic');
    box.style.display = 'block';
    box.style.visibility = 'hidden';
}

function reset() {
    const box = document.getElementById('magic');
    box.style.display = 'block';
    box.style.visibility = 'visible';
}
/* I am using the onclick event to run the functions when the buttons are clicked. Then I get the element by Id and change the css properties as requested in the exercise  */

/* Part 6 */
const technologies = [
    'HTML5',
    'CSS3',
    'JavaScript',
    'Python',
    'Java',
    'AJAX',
    'JSON',
    'React',
    'Angular',
    'Bootstrap',
    'Node.js'
];
const list = document.getElementById('tech');
for (let i = 0; i < technologies.length; i++) {
    const element = document.createElement('li');
    element.innerHTML = technologies[i];
    list.appendChild(element);
}
/* Here I first get the element of the unordered list by Id, then I run a loop for the length of the technologies list. In the loop for each element I create a list item tag then I assign it to its corresponding element in the technologies list and finally add it to the unordered list */