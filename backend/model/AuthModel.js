// backend/model/Authmodel.js

// Import the mongoose module
const mongoose = require('mongoose');

// Define the schema for authentication data
const authSchema = new mongoose.Schema({
    name: String,       // Name of the user
    email: String,      // Email of the user
    password: String,   // Hashed password of the user
    type: Number        // Type of user (e.g., 0 for regular user, 1 for admin)
});

// Export the mongoose model for authentication
module.exports = mongoose.model('AUTH', authSchema);
