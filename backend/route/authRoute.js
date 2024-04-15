// backend/route/authRoute.js

// Import required modules
const express = require('express');
const router = express.Router();
const { signup, login } = require('../logic/authLogic'); // Import signup and login functions
const { body, validationResult } = require('express-validator'); // Import body function for validation


// Route for user signup
router.post('/signup', [
  // Validate and sanitize fields using express-validator
  body('email').trim().isEmail().normalizeEmail().withMessage('Invalid email'),
  body('password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters long'),
  // Add validation for user type
  body('type').isIn(['user', 'agency']).withMessage('Invalid user type'), // Validate user type
], async (req, res) => { // Use async for cleaner handling of validation errors
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() }); // Return validation errors
    }

    // Pass request body directly to signup function (no need to extract fields manually)
    await signup(req, res);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Internal server error' });
  }
});


// Route for user login
router.post('/login', [
    // Validate fields as before

    body('email').trim().isEmail().normalizeEmail().withMessage('Invalid email'),
  body('password').notEmpty().withMessage('Password is required'),
], async (req, res) => { // Use async for cleaner handling of validation errors
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() }); // Return validation errors
    }

    // Pass request body directly to login function
    await login(req, res);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Internal server error' });
}
});

// Export the router
module.exports = router;