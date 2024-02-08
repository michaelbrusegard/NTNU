const button = document.getElementById('addTask');
const input = document.getElementById('input');
const ul = document.getElementById('ul');
const output = document.getElementById('output');

button.addEventListener('click', addTask);
ul.addEventListener('change', strikethroughOnCheck);

const tasks = [];

let completedTasks = 0;
let currentTasks = 0;
updateOutput();


function addTask() {
    const li = document.createElement('li');

    const date = new Date();
    const dateIso = date.toISOString();
    const dateMilliseconds = Date.parse(dateIso);
    const task = { date: dateMilliseconds, value: input.value };
    tasks.push(task);
    console.log(tasks);

    const checkbox = document.createElement('input');
    checkbox.type = 'checkbox';

    const text = document.createTextNode(task.value);

    li.appendChild(checkbox);
    li.appendChild(text);

    ul.insertBefore(li, ul.firstChild);

    currentTasks = tasks.length;
    updateOutput();
}

function strikethroughOnCheck() {
    const checkboxes = document.querySelectorAll('input');
    let checkedBoxes = 0;

    for (let i = 0; i < checkboxes.length; i++) {
        if (checkboxes[i].checked === true) {
            checkboxes[i].parentNode.style.setProperty('text-decoration', 'line-through');
            checkedBoxes += 1;
        } else {
            checkboxes[i].parentNode.style.setProperty('text-decoration', 'none');
        }
    }

    completedTasks = checkedBoxes;
    updateOutput();
}

function updateOutput() {
    output.textContent = `${completedTasks}/${currentTasks} completed`;
}