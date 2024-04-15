//backend/config/db.js
const mongoose = require('mongoose');
require('dotenv').config();


const MONGODB_URI = process.env.MONGODB_URI;

// Connect to MongoDB
mongoose.connect(MONGODB_URI);
const connection = mongoose.connection;
connection.on("connected", () => { console.log("connected with mongoDB successfully...!"); });
connection.on("error", (error) => { console.log("there is a problem with mongoDB", error); });

module.exports = connection;