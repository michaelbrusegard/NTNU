function daysTo17May() {
    const today = new Date();
    const may17 = new Date(today.getFullYear(), 5, 17);
    let ms;
    let tall;
    if (today <= may17) {
        ms = may17 - today;
    } else {
        ms = may17 - today + 365 * 24 * 60 * 60 * 1000;
    }
    const days = Math.floor(ms / (1000 * 60 * 60 * 24));
    if (days % 2 == 0) {
        tall = "partall"
    } else {
        tall = "oddetall"
    }

    console.log("days to 17. May = ", days, "som er", tall);
}

daysTo17May();