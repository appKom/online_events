const express = require('express');
const fetch = require('node-fetch');
const fs = require('fs');
const https = require('https');

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

app.get("/callback", async (req, res, next) => {
    const body = new URLSearchParams();

    body.append("grant_type", "authorization_code");
    body.append("code", req.query.code);
    body.append("redirect_uri", REDIRECT_URI);
    body.append("client_id", CLIENT_ID.toString());

    const authorization = await fetch("https://old.online.ntnu.no/openid/token", {
        method: "POST",
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        },
        body: body
    }).then(response => response.json());
    console.log("Access Token:", authorization.access_token);
    const profile = await fetch("https://old.online.ntnu.no/api/v1/profile", {
        headers: {
            "Authorization": `${authorization.token_type} ${authorization.access_token}`
        }
    }).then(response => response.json());

    res.cookie("profile", JSON.stringify(profile));
    res.redirect("/");
});

app.get('/', (req, res) => {
    res.send('Welcome to the Application!');
    
});

app.use(express.static('public'));
app.listen(3000, () => console.log("Kjører server på http://localhost:3000"));