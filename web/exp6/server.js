const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

let existingUsernames = ['john123', 'alice2022', 'mike88', 'pratik11', 'user123', 'student456', 'admin007', 'guest999', 'rajpatil', 'techguy'];

app.post('/check-username', (req, res) => {
  const { username } = req.body;
  const exists = existingUsernames.includes(username.toLowerCase());
  res.json({ exists });
});

app.post('/register', (req, res) => {
  const { username } = req.body;
  if (existingUsernames.includes(username.toLowerCase())) {
    return res.json({ message: "Username already taken." });
  }
  existingUsernames.push(username.toLowerCase());
  res.json({ message: "Successfully Registered!" });
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});
