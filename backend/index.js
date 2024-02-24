// backend/index.js

// Import required modules
const express = require('express');
const app = express();
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const cors = require('cors');
const ContactRouter = require('./route/contactRouter'); // Import router for handling contact-related routes
const AuthRouter = require('./route/authRoute'); // Import router for handling authentication-related routes
const user_check = require('./middleware/verify_user'); // Import middleware for verifying user access
const admin_check = require('./middleware/verify_admin'); // Import middleware for verifying admin access
const rateLimit = require("express-rate-limit"); // Import express-rate-limit for rate limiting

// Connect to MongoDB
mongoose.connect('mongodb://localhost:27017/contacts');
const connection = mongoose.connection;
connection.on("connected", () => { console.log("connected with mongoDB successfully...!"); });
connection.on("error", (error) => { console.log("there is a problem with mongoDB", error); });


// Middleware and parsers
app.use([bodyParser.urlencoded({ extended: true }), cors(), express.json(), express.urlencoded({ extended: true })]);

// Rate Limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100 // limit each IP to 100 requests per windowMs
});
app.use(limiter);


// Routes
app.use('/auth', AuthRouter); // Route for authentication
app.get('/contacts', user_check); // Route for retrieving contacts (accessible to users)
app.post('/contacts', admin_check); // Route for inserting contacts (accessible to admins)
app.use('/contacts', ContactRouter); // Route for contact-related operations

// Error Handling Middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({ message: 'Internal Server Error' });
});

// Start the server
const port = 8080;
app.listen(port, () => {
    console.log("connected with the server on port" + " " + port);
});

// Export the app
module.exports = app;
