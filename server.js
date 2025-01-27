require("dotenv").config();
const express = require("express");
const mongoose = require("mongoose");
const userRoutes = require("./routes/users");
const bloodRoutes = require("./routes/bloods");
const cors = require("cors");

// Express app
const app = express();

// Middleware
app.use(express.json());
app.use(cors());
app.use((req, res, next) => {
    console.log(req.path, req.method);
    next();
});

// Routes
app.use('/api/users', userRoutes);
app.use('/api/bloods', bloodRoutes);

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