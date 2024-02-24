// backend/logic/authLogic.js

// Import required modules
const AUTH = require('../model/AuthModel'); // Importing the AuthModel for database operations
const bcrypt = require('bcrypt'); // Importing bcrypt for password hashing
const jwt = require('jsonwebtoken'); // Importing jsonwebtoken for token generation
const { validationResult } = require('express-validator'); // Importing validationResult for request validation

// Exporting functions related to authentication logic
module.exports = {
    // Function for user signup
    signup: async (req, res) => {
        try {
            // Input Validation
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(400).json({ errors: errors.array() }); // Return validation errors if any
            }

            // Check if user with provided email already exists
            const user = await AUTH.find({ email: req.body.email });
            if (user.length >= 1) {
                return res.status(400).json({ message: "This email is already used" }); // Return error if email is already in use
            } else {
                // Hash the password before saving it to the database
                bcrypt.hash(req.body.password, 10, async (error, hash) => {
                    if (error) {
                        return res.status(500).json({ message: 'Error in password' }); // Return error if password hashing fails
                    } else {
                        // Save user details to the database
                        const auth = await new AUTH({
                            name: req.body.name,
                            email: req.body.email,
                            password: hash,
                            type: req.body.type
                        }).save();
                        // Return success message and user details
                        res.status(201).json({
                            message: "Create user successfully",
                            email: auth.email,
                            type: auth.type
                        });
                    }
                });
            }
        } catch (error) {
            console.error('Error in signup:', error);
            res.status(500).json({ message: 'Internal Server Error' }); // Return internal server error if an exception occurs
        }
    },
  
    // Function for user login
    login: async (req, res) => {
        try {
            // Input Validation
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(400).json({ errors: errors.array() }); // Return validation errors if any
            }
      
            // Check if user with provided email exists
            const user = await AUTH.find({ email: req.body.email });
            if (user.length < 1) {
                return res.status(401).json({ message: 'This email does not exist' }); // Return error if user does not exist
            } else {
                // Compare provided password with hashed password in the database
                bcrypt.compare(req.body.password, user[0].password, (error, result) => {
                    if (error) {
                        return res.status(401).json({ message: 'Password not exist' }); // Return error if password comparison fails
                    }
                    if (result) {
                        // Generate JWT token if password matches
                        const token = jwt.sign({ email: user[0].email, name: user[0].name }, user[0].type === 0 ? "USER" : "ADMIN");
                        // Return success message, user type, email, and token
                        return res.status(200).json({
                            message: user[0].type === 0 ? "User logged in" : "Admin logged in",
                            type: user[0].type,
                            email: user[0].email,
                            token: token
                        });
                    }
                });
            }
        } catch (error) {
            console.error('Error in login:', error);
            res.status(500).json({ message: 'Internal Server Error' }); // Return internal server error if an exception occurs
        }
    }
}
