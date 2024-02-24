// backend/route/authRoute.js

// Import required modules
const express = require('express');
const router = express.Router();
const { signup, login } = require('../logic/authLogic'); // Import signup and login functions from authLogic
const { body } = require('express-validator'); // Import body function from express-validator

// Route for user signup
router.post('/signup', [
    // Validate and sanitize fields using express-validator
    body('name').trim().notEmpty().withMessage('Name is required'), // Name validation
    body('email').trim().isEmail().normalizeEmail().withMessage('Invalid email'), // Email validation
    body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters long'), // Password validation
], signup); // Call signup function when POST request is made to '/signup' route

// Route for user login
router.post('/login', [
    // Validate and sanitize fields using express-validator
    body('email').trim().isEmail().normalizeEmail().withMessage('Invalid email'), // Email validation
    body('password').notEmpty().withMessage('Password is required'), // Password validation
], login); // Call login function when POST request is made to '/login' route

// Export the router
module.exports = router;



/* 
*I use express-validator to define validation rules for each field in the request body.
*For the signup route, I ensure that the name, email, and password fields are present and meet certain criteria 
(e.g., non-empty, valid email format, minimum password length).
*For the login route, I validate the email and password fields similarly.
*If any validation rule fails, an array of validation errors will be returned in the response, 
allowing the client to correct the input data. */