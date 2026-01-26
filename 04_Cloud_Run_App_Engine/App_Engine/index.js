const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send('Hello from Google App Engine! 👋- I updated this and its Version 1.0');
});

// Listen to the App Engine-specified port, or 8080 otherwise
const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}...`);
});
