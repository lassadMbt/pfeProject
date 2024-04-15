// backend/logic/authLogic.js

// Import required modules
const AUTH = require("../model/AuthModel"); // Correct import statement for the model
const jwt = require("jsonwebtoken"); // Importing jsonwebtoken for token generation
const { validationResult } = require("express-validator"); // Importing validationResult for request validation
const bcrypt = require("bcrypt");

async function comparePassword(user, enteredPassword) {
  return await bcrypt.compare(enteredPassword, user.password);
}
// Access the JWT secret key from the environment variable
const JWT_SECRET_USER = process.env.JWT_SECRET_USER;
const JWT_SECRET_AGENCY = process.env.JWT_SECRET_AGENCY;

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
      const user = await AUTH.findOne({ email: req.body.email });
      if (user) {
        return res.status(400).json({ message: "This email is already used" }); // Return error if email is already in use
      }

      // Create a new user object based on the type
      let newUser;
      if (req.body.type === "user") {
        newUser = new AUTH({
          email: req.body.email,
          password: req.body.password,
          type: req.body.type,
          name: req.body.name,
          language: req.body.language,
          country: req.body.country,
        });
      } else if (req.body.type === "agency") {
        newUser = new AUTH({
          email: req.body.email,
          agencyName: req.body.agencyName, // Include agencyName
          password: req.body.password,
          type: req.body.type,
          location: req.body.location,
          description: req.body.description,
        });
      } else {
        return res.status(400).json({ message: " Invalid user type" });
      }

      // Save user details to the database
      await newUser.save();

      // Return success message and user details
      res.status(201).json({
        message: "User created successfully",
        email: newUser.email,
        type: newUser.type,
      });
    } catch (error) {
      console.error("Error in signup:", error);
      res.status(500).json({ message: "Internal Server Error" }); // Return internal server error if an exception occurs
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
      const user = await AUTH.findOne({ email: req.body.email });
      if (!user) {
        return res.status(401).json({ message: "This email does not exist" }); // Return error if user does not exist
      }

      // Compare provided password with hashed password in the database
      const isMatch = await comparePassword(user, req.body.password);
      if (!isMatch) {
        return res.status(401).json({ message: "Invalid password" }); // Return error if password is incorrect
      }

      // Generate JWT token
      const token = jwt.sign(
        { email: user.email, name: user.name },
        user.type === "user" ? JWT_SECRET_USER : JWT_SECRET_AGENCY
      );

      // Return success message, user type, email, and token
      res.status(200).json({
        message: user.type === "user" ? "User logged in" : "Agency logged in",
        type: user.type,
        email: user.email,
        token: token,
      });
    } catch (error) {
      console.error("Error in login:", error);
      res.status(500).json({ message: "Internal Server Error" }); // Return internal server error if an exception occurs
    }
  },
};
