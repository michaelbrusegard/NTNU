const income = document.getElementById('income')
const wealth = document.getElementById('wealth')
const tax = document.getElementById('tax')

function calculate() {
    tax.value = (0.35 * income.value) + (0.25 * wealth.value)
}

income.addEventListener("input", () => calculate());
wealth.addEventListener("input", () => calculate());