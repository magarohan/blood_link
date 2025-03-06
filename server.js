require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const donorRoutes = require("./routes/donors");
const bloodRoutes = require("./routes/bloods");
const requestRoutes = require("./routes/requests");
const hopitalRoutes = require("./routes/hospitalBloods");
const cors = require("cors");

// Express app
const app = express();

// Middleware
app.use(express.json());
app.use(cors());
app.use((req, res, next) => {
    console.log(`Request: ${req.method} ${req.path}, Query:`, req.query);
    next();
});


// Routes
app.use('/api/donors', donorRoutes);
app.use('/api/bloods', bloodRoutes);
app.use('/api/requests', requestRoutes);
app.use('/api/hospitalBloods', hopitalRoutes);


// Connect to DB
mongoose.connect(process.env.MONGO_URI)
    .then(() => {
        console.log("Connected to DB");
        // Listen for requests
        app.listen(process.env.PORT, () => {
            console.log("Listening on port", process.env.PORT);
        });
    })
    .catch((error) => {
        console.log(error);
    });