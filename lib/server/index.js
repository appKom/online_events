const express = require('express');

const CLIENT_ID = 972717;
const REDIRECT_URI = "http://10.0.2.2:3000/callback";

const app = express();

app.get("/login", (req, res) => {
    res.status(302);
    res.redirect(
        `https://old.online.ntnu.no/openid/authorize?` +
        `client_id=${CLIENT_ID}` +
        `&redirect_uri=${encodeURIComponent(REDIRECT_URI)}` +
        `&response_type=code` +
        `&scope=openid+profile+onlineweb4`
    );
});

app.get("/callback", (req, res) => {
    // The callback simply displays the code or an error message
    if (req.query.code) {
        res.send(`Authorization code: ${req.query.code}. Please close this window and return to the app.`);
    } else {
        res.send('Error: No authorization code received.');
    }
});

app.get('/', (req, res) => {
    res.send('Welcome to the Application!');
});

app.listen(3000, () => console.log("Server running on http://10.0.2.2:3000"));