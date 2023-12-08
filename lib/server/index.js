const express = require('express');

const CLIENT_ID = 972717;
const REDIRECT_URI = "http://10.0.2.2:3000/callback";
const path = require('path');

const app = express();

app.get("/login", (req, res) => {
    res.status(302);
    res.redirect(
        `https://old.online.ntnu.no/openid/authorize?` +
        `client_id=${CLIENT_ID}` +
        `&redirect_uri=${encodeURIComponent(REDIRECT_URI)}` +
        `&response_type=code` +
        `&scope=openid+profile+onlineweb4+events`
    );
});

app.use('/images', express.static(path.join(__dirname, '../../assets/images')));

app.get("/callback", (req, res) => {
    // The callback simply displays the code or an error message
    if (req.query.code) {
        res.send(`
            <html>
                <head>
                    <style>
                        body {
                            display: flex;
                            justify-content: center;
                            align-items: center;
                            height: 100vh; /* Full height of the viewport */
                            margin: 0; /* Reset default margin */
                        }
                        img {
                            max-width: 100%; /* Ensure image is not bigger than the viewport */
                            height: auto; /* Maintain the aspect ratio */
                        }
                    </style>
                </head>
                <body>
                <img src="/images/subkom.png" alt="Dotkom tripper" />
                </body>
            </html>
        `);
    } else {
        res.send('Error: No authorization code received.');
    }
});

app.get('/', (req, res) => {
    res.send('Welcome to the Application!');
});

app.listen(3000, () => console.log("Server running on http://10.0.2.2:3000"));