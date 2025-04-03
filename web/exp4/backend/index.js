const express = require('express');
const connectDB = require('./config/db');
const cors = require('cors');
const router = require('./routes/student');
require('dotenv').config();

const app = express();

// Connect to MongoDB
connectDB();

// Middleware
app.use(cors());
app.use(express.json()); // Body parser middleware

// Routes
app.use('/api', router);

// Server Listening
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
